package io.github.tobiasz.testproject.snapshots;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class RenameSnapshot {

    private String username;

    public static void testMethod() {
        RenameSnapshot renameSnapshot = RenameSnapshot.builder().username("username").build();
        renameSnapshot.setUsername("bob");
        System.out.println(renameSnapshot.getUsername());
    }
}
