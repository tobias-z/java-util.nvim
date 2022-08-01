local mock = require("luassert.mock")

describe("util", function()
  local util = require("java_util.lsp.util")

  describe("request_all", function()
    local mock_lsp

    after_each(function()
      mock.revert(mock_lsp)
    end)

    local function was_called(params, fn)
      mock_lsp = mock(vim.lsp, true)
      mock_lsp.buf_request.invokes(fn)
      local called = false
      util.request_all(params, function()
        called = true
      end)
      return called
    end

    it("given 4 requests when all are succesful then call the callback", function()
      local called = was_called({
        { bufnr = 0, method = "textDocument/references", params = {} },
        { bufnr = 0, method = "textDocument/references", params = {} },
        { bufnr = 0, method = "textDocument/references", params = {} },
        { bufnr = 0, method = "textDocument/definition", params = {} },
      }, function(_, _, _, fn)
        fn()
      end)

      assert.is_true(called)
    end)

    it("given 2 requests when one fails then dont call the callback", function()
      local count = 0
      local called = was_called({
        { bufnr = 0, method = "textDocument/references", params = {} },
        { bufnr = 0, method = "textDocument/definition", params = {} },
      }, function(_, _, _, fn)
        if count < 1 then
          fn()
        end
        count = count + 1
      end)

      assert.is_false(called)
    end)

    it("given 2 requests when all fails then dont call the callback", function()
      local called = was_called({
        { bufnr = 0, method = "textDocument/references", params = {} },
        { bufnr = 0, method = "textDocument/definition", params = {} },
      }, function(_, _, _, _) end)

      assert.is_false(called)
    end)
  end)
end)
