package io.github.tobiasz.testproject.builders;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class RenameLombokField {

    private String username;

    public static void testMethod() {
        RenameLombokField renameLombokField =
                RenameLombokField.builder().username("username").build();
        renameLombokField.setUsername("bob");
        System.out.println(renameLombokField.getUsername());
    }
}
