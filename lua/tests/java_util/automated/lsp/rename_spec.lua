local helpers = require("tests.java_util.util.helpers")

describe("rename", function()
  it("Can rename field aswell as lombok builder, setter and getter", function()
    local match = helpers.snapshot_matches(
      "RenameLombokField",
      [[
package io.github.tobiasz.testproject.builders;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class RenameLombokField {

    private String changed;

    public static void testMethod() {
        RenameLombokField renameLombokField =
                RenameLombokField.builder().changed("username").build();
        renameLombokField.setChanged("bob");
        System.out.println(renameLombokField.getChanged());
    }
}]]
    )

    assert.is_true(match)
  end)
end)
