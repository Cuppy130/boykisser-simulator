package main;

public class Main {
    public static void main(String[] args) {
        Window window = new Window(800, 600, "Boykisser Simulator");
        window.setIcon("/res/boykisser.png");
        window.loop();
        window.exit();
    }
}