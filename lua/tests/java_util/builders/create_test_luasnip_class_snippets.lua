require("java_util").setup({
  test = {
    use_defaults = false,
    class_snippets = {
      ["Simple"] = function(info)
        return require("luasnip").parser.parse_snippet(
          "_",
          string.format(
            [[
package %s;

public class %s {

}]],
            info.package,
            info.classname
          )
        )
      end,
    },
  },
})

-- Make sure we don't already have the test file
vim.cmd(
  "!rm -f lua/tests/testproject/src/test/java/io/github/tobiasz/testproject/builders/CreateTestLuasnipClassSnippetsTest.java"
)

require("java_util.lsp").create_test({ class_snippet = "Simple", testname = "CreateTestLuasnipClassSnippetsTest" })
