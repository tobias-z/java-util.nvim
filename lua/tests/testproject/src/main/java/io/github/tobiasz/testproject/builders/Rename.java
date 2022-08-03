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
}
