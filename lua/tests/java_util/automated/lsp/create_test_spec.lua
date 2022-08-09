local helpers = require("tests.java_util.util.helpers")

local ok = assert.is_true

describe("create_test", function()
  it("creates empty test file when no class_snippets are found", function()
    ok(helpers.snapshot_matches("CreateTestNoClassSnippets", ""))
  end)

  it("creates test with class content when using string class_snippet", function()
    ok(helpers.snapshot_matches(
      "CreateTestStringClassSnippets",
      [[
package io.github.tobiasz.testproject.builders;

public class CreateTestStringClassSnippetsTest {

}]]
    ))
  end)

  it("creates test with class content when using luasnip class_snippet", function()
    ok(helpers.snapshot_matches(
      "CreateTestLuasnipClassSnippets",
      [[
package io.github.tobiasz.testproject.builders;

public class CreateTestLuasnipClassSnippetsTest {

}]]
    ))
  end)
end)
