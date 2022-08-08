local fs_util = require("java_util.fs_util")
local lsp_util = require("java_util.lsp.util")

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
  vim.ui.input({ prompt = "Test name:", default = default_testname }, function(test_filename)
    if not test_filename then
      return
    end

    local file = string.format("%s/%s.java", test_location, test_filename)
    if fs_util.file_exists(file) then
      with_filepath(test_location, test_filename, callback)
      return
    end

    callback(file)
  end)
end

function create_test.create_test()
  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local default_filename = string.format("%sTest", string.sub(bufname, string.find(bufname, "/[^/]*$") + 1, -6))

  local removed_filename = up_directory(bufname)
  local src_root = get_src_root(removed_filename)
  local location = string.gsub(removed_filename, src_root .. "/main", src_root .. "/test")

  with_filepath(location, default_filename, function(filepath)
    fs_util.ensure_directory(location)
    fs_util.create_file(filepath)

    local package = lsp_util.get_test_package(src_root, location)
    print(package)
    -- TODO: Select which test you want to use. Read from config
    -- Insert the selected test to the file
  end)
end

return create_test
