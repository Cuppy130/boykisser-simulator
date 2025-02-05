package main;

import java.util.ArrayList;
import java.util.List;

public class Boys {
    public static List<Boy> boys = new ArrayList<>();

    public static void drawBoys() {
        for(Boy boy : boys) {
            boy.render();
        }
    }
}
