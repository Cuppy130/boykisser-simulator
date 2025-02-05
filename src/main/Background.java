package main;

import static org.lwjgl.opengl.GL11.*;

public class Background {
    public static void draw() {
        glBegin(GL_QUADS);
        glTexCoord2f(0, 0); glVertex2f(-400, -300);
        glTexCoord2f(1, 0); glVertex2f(400, -300);
        glTexCoord2f(1, 1); glVertex2f(400, 300);
        glTexCoord2f(0, 1); glVertex2f(-400, 300);
        glEnd();
    }
}
