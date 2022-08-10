require("java_util").setup({
  test = {
    use_defaults = false,
  },
})

-- Make sure we don't already have the test file
vim.cmd(
  "!rm -f lua/tests/testproject/src/test/java/io/github/tobiasz/testproject/builders/CreateTestNoClassSnippetsTest.java"
)

require("java_util.lsp").create_test({ testname = "CreateTestNoClassSnippetsTest" })
