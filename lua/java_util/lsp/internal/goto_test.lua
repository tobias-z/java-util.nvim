local lsp_util = require("java_util.lsp.util")
local plenary_util = require("java_util.plenary_util")

local goto_test = {}

local function goto_test_class(opts)
  goto_test.with_test_classes(opts, function(test_classes)
    print(vim.inspect(test_classes))
  end)
end

function goto_test.with_test_classes(opts, callback)
  local test_classes = {}
  plenary_util.execute_with_results({
    cmd = "find",
    args = {
      opts.src_root .. "/test",
      "-name",
      string.format("%s*", opts.current_class),
    },
    process_result = function(line)
      table.insert(test_classes, line)
    end,
    process_complete = function()
      callback(test_classes)
    end,
  })
end

function goto_test.goto_test(opts)
  opts = opts or {}
  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local src_root = lsp_util.get_src_root(bufname)
  local current_class = string.sub(bufname, string.find(bufname, "/[^/]*$") + 1, -6)

  local is_in_main = string.find(bufname, src_root .. "/main") ~= nil
  if is_in_main then
    goto_test_class({ src_root = src_root, current_class = current_class })
  else
    print("in test")
  end
end

return goto_test
