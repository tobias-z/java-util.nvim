local fs_util = require("java_util.fs_util")
local lsp_util = require("java_util.lsp.util")
local values = require("java_util.config").values

local create_test = {}

--- Changes /src/main to /src/test in the closest src_root to the current class
local function get_test_location(src_root, filepath)
  local root_split = vim.split(string.sub(src_root, 2), "/")

  local test_location = ""
  for i, dir in ipairs(vim.split(string.sub(filepath, 2), "/")) do
    -- is main folder
    if i ~= #root_split + 1 then
      test_location = string.format("%s/%s", test_location, dir)
    else
      test_location = string.format("%s/test", test_location)
    end
  end

  return test_location
end

local function with_filepath(opts)
  if opts.testname then
    local file = string.format("%s/%s.java", opts.test_location, opts.testname)
    if fs_util.file_exists(file) then
      vim.notify(string.format("file: '%s' already exists", file), vim.log.levels.ERROR)
      return
    end
    opts.callback(file, opts.testname)
    return
  end

  vim.ui.input({ prompt = "Test class name:", default = opts.default_testname }, function(test_filename)
    if not test_filename then
      return
    end

    local file = string.format("%s/%s.java", opts.test_location, test_filename)
    if fs_util.file_exists(file) then
      with_filepath({ test_location = opts.test_location, default_testname = test_filename, callback = opts.callback })
      return
    end

    opts.callback(file, test_filename)
  end)
end

local function get_class_snippet_name(opts)
  local class_snippets = values.test.class_snippets
  if opts.class_snippet then
    return opts.class_snippet
  end
  return vim.tbl_keys(class_snippets)[1]
end

local function after_snippet(opts)
  local a_snippet = values.test.after_snippet
  if a_snippet and type(a_snippet) == "function" then
    a_snippet(opts)
  end
end

---@param opts table
---@field filename string
---@field class_snippet function
---@filed classname string
---@filed package string
local function create_class(opts)
  local uri = string.format("file://%s", opts.filepath)
  local bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(bufnr)

  local create_snip = opts.class_snippet({ package = opts.package, classname = opts.classname })
  local is_luasnip = type(create_snip) == "table" and create_snip.snippet ~= nil

  if type(create_snip) == "string" then
    lsp_util.jump_to_file(uri)
    local lines = vim.split(create_snip, "\n")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  elseif is_luasnip then
    local ok, luasnip = pcall(require, "luasnip")
    if ok then
      lsp_util.jump_to_file(uri)
      luasnip.snip_expand(create_snip)
    end
  else
    vim.notify("Unsupported return value from class snippet", vim.log.levels.WARN)
    return
  end

  after_snippet({ snippet = opts.snip_name, is_luasnip = is_luasnip })
end

function create_test.create_test(opts)
  opts = opts or {}
  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local default_filename = string.format("%sTest", string.sub(bufname, string.find(bufname, "/[^/]*$") + 1, -6))

  local removed_filename = lsp_util.up_directory(bufname)
  local src_root = lsp_util.get_src_root(removed_filename)
  local location = get_test_location(src_root, removed_filename)

  with_filepath({
    testname = opts.testname,
    test_location = location,
    default_testname = default_filename,
    callback = function(filepath, classname)
      local class_snippets = values.test.class_snippets
      local package = lsp_util.get_test_package(src_root, location)

      if opts.class_snippet and not class_snippets[opts.class_snippet] then
        vim.notify("Unknown class snippet: " .. opts.class_snippet, vim.log.levels.ERROR)
        return
      end

      local snip_len = vim.tbl_count(class_snippets)
      if snip_len == 0 or snip_len == 1 or opts.class_snippet then
        fs_util.ensure_directory(location)
        fs_util.create_file(filepath)
      end

      if snip_len == 0 then
        lsp_util.jump_to_file(string.format("file://%s", filepath))
        after_snippet({})
      elseif snip_len == 1 or opts.class_snippet then
        local name = get_class_snippet_name(opts)
        create_class({
          filepath = filepath,
          classname = classname,
          package = package,
          class_snippet = class_snippets[name],
          snip_name = name,
        })
      else
        vim.ui.select(vim.tbl_keys(class_snippets), {
          prompt = "Test snippet to use:",
        }, function(choice)
          fs_util.ensure_directory(location)
          fs_util.create_file(filepath)
          create_class({
            filepath = filepath,
            classname = classname,
            package = package,
            class_snippet = class_snippets[choice],
            snip_name = choice,
          })
        end)
      end
    end,
  })
end

return create_test
