local lsp_util = require("java_util.lsp.util")
local plenary_util = require("java_util.plenary_util")
local string_util = require("java_util.string_util")

local goto_test = {}

--- Sorts the classes by classname length, smallest should be on top
--- So the closest match is always the top one
local function get_sorted_classes(classes)
  local keys = vim.tbl_keys(classes)
  return vim.fn.sort(keys, function(c1, c2)
    local c1_len = string.len(string.sub(c1, string_util.last_index_of(c1, "/") + 1))
    local c2_len = string.len(string.sub(c2, string_util.last_index_of(c2, "/") + 1))
    if c1_len > c2_len then
      return 1
    elseif c1_len == c2_len then
      return 0
    else
      return -1
    end
  end)
end

local function handle_results(opts, classes)
  local found_len = vim.tbl_count(classes)
  if found_len == 0 then
    if opts.on_no_results then
      opts.on_no_results(opts)
    end
    return
  elseif found_len == 1 then
    local first = classes[vim.tbl_keys(classes)[1]]
    lsp_util.jump_to_file(string.format("file://%s", first))
  else
    vim.ui.select(
      get_sorted_classes(classes),
      { prompt = string.format("Choose class (%d, found)", found_len) },
      function(item)
        local choosen = classes[item]
        lsp_util.jump_to_file(string.format("file://%s", choosen))
      end
    )
  end
end

function goto_test.__with_test_results(opts, callback)
  local cwd = vim.fn.getcwd()
  local test_classes = {}
  plenary_util.execute_with_results({
    cmd = "find",
    cwd = opts.src_root .. "/test",
    args = {
      string.format("%s/test", opts.src_root),
      "-name",
      string.format("%s*", opts.current_class),
    },
    process_result = function(line)
      -- make the result start from src/...
      local shortened = string.sub(line, string.len(cwd) + 2)
      if opts.filter and type(opts.filter) == "function" then
        if not opts.filter(shortened) then
          return
        end
      end

      test_classes[shortened] = line
    end,
    process_complete = function()
      vim.schedule(function()
        callback(opts, test_classes)
      end)
    end,
  })
end

function goto_test.goto_test(opts)
  opts = opts or {}
  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local src_root = lsp_util.get_src_root(bufname)
  local current_class = string.sub(bufname, string.find(bufname, "/[^/]*$") + 1, -6)
  local is_in_main = string.find(bufname, string.format("%s/main", src_root)) ~= nil
  if is_in_main then
    goto_test.__with_test_results(
      vim.tbl_extend("force", { src_root = src_root, current_class = current_class }, opts),
      handle_results
    )
  else
    print("in test")
  end
end

return goto_test
