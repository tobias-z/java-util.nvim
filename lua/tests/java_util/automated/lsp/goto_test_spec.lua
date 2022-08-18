local helpers = require("tests.java_util.util.helpers")

local ok = assert.is_true

describe("goto_test", function()
  it("can go to a test from none test class", function()
    ok(helpers.snapshot_matches(
      "GotoTest",
      [[
package io.github.tobiasz.testproject.builders;

public class GotoTestTest {}]]
    ))
  end)
end)
