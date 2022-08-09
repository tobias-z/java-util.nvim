local fs_util = require("java_util.fs_util")
local lsp_util = require("java_util.lsp.util")
local values = require("java_util.config").values

local create_test = {}

local function up_directory(path)
  return vim.fn.fnamemodify(path, ":h")
end

local function get_src_root(path)
  while not vim.endswith(path, "/src") do
    path = up_directory(path)

    if path == "/" then
      error("unable to find src root")
    end
  end

  return path
end

local function with_filepath(test_location, default_testname, callback)
  vim.ui.input({ prompt = "Test class name:", default = default_testname }, function(test_filename)
    if not test_filename then
      return
    end

    local file = string.format("%s/%s.java", test_location, test_filename)
    if fs_util.file_exists(file) then
      with_filepath(test_location, test_filename, callback)
      return
    end

    callback(file, test_filename)
  end)
end

---@param opts table
---@field filename string
---@field class_snippet function
---@filed classname string
---@filed package string
local function insert_snippet_in_file(opts)
  local uri = string.format("file://%s", opts.filepath)
  local bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(bufnr)

  local create_snip = opts.class_snippet({ package = opts.package, classname = opts.classname })

  if type(create_snip) == "string" then
    lsp_util.jump_to_file(uri)
    local lines = vim.split(create_snip, "\n")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  elseif type(create_snip) == "table" and create_snip.snippet ~= nil then
    local ok, luasnip = pcall(require, "luasnip")
    if ok then
      lsp_util.jump_to_file(uri)
      luasnip.snip_expand(create_snip)
    end
  else
    vim.notify("Unsupported return value from class snippet")
  end
end

local function after_snippet(opts)
  local a_snippet = values.lsp.test.after_snippet
  if a_snippet and type(a_snippet) == "function" then
    a_snippet(opts)
  end
end

function create_test.create_test()
  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local default_filename = string.format("%sTest", string.sub(bufname, string.find(bufname, "/[^/]*$") + 1, -6))

  local removed_filename = up_directory(bufname)
  local src_root = get_src_root(removed_filename)
  local location = string.gsub(removed_filename, src_root .. "/main", src_root .. "/test")

  with_filepath(location, default_filename, function(filepath, classname)
    fs_util.ensure_directory(location)
    fs_util.create_file(filepath)

    local class_snippets = values.lsp.test.class_snippets
    local package = lsp_util.get_test_package(src_root, location)

    local snip_len = vim.tbl_count(class_snippets)
    if snip_len == 0 then
      lsp_util.jump_to_file(string.format("file://%s", filepath))
      after_snippet({})
    elseif snip_len == 1 then
      local name
      for key, _ in pairs(class_snippets) do
        name = key
      end
      insert_snippet_in_file({
        filepath = filepath,
        classname = classname,
        package = package,
        class_snippet = class_snippets[name],
      })
      after_snippet({ snippet = name })
    else
      vim.ui.select(vim.tbl_keys(class_snippets), {
        prompt = "Test snippet to use:",
      }, function(choice)
        insert_snippet_in_file({
          filepath = filepath,
          classname = classname,
          package = package,
          class_snippet = class_snippets[choice],
        })
        after_snippet({ snippet = choice })
      end)
    end
  end)
end

return create_test
