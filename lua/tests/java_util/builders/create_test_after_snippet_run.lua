require("java_util").setup({
  test = {
    use_defaults = false,
    after_snippet = function()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "// hello world" })
    end,
    class_snippets = {
      ["Simple"] = function()
        return ""
      end,
    },
  },
})

-- Make sure we don't already have the test file
vim.cmd(
  "!rm -f lua/tests/testproject/src/test/java/io/github/tobiasz/testproject/builders/CreateTestAfterSnippetRunTest.java"
)

require("java_util.lsp").create_test({ class_snippet = "Simple", testname = "CreateTestAfterSnippetRunTest" })
