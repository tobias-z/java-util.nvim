local helpers = require("tests.java_util.util.helpers")

describe("rename", function()
  it("Can rename field aswell as lombok builder, setter and getter", function()
    helpers.build_snapshot("Rename.java", "rename")
    local match = helpers.snapshot_matches(
      "Rename.java",
      [[
package io.github.tobiasz.testproject.builders;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class Rename {

    private String username;

    public static void testMethod() {
        Rename renameSnapshot = Rename.builder().username("username").build();
        renameSnapshot.setUsername("bob");
        System.out.println(renameSnapshot.getUsername());
    }
}]]
    )
    assert.is_true(match)
  end)
end)
