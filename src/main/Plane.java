package main;

import static org.lwjgl.opengl.GL30.*;

import org.joml.Vector3f;

public class Plane {
    private Vector3f color;
    private float x;
    private float y;
    private float width;
    private float height;


    public Plane(float x, float y, float width, float height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public void setColor(Vector3f color) {
        this.color = color;
    }

    public void render(){
        if(color != null){
            glColor3f(color.x, color.y, color.z);
        }

        glBegin(GL_QUADS);
        glTexCoord2f(0, 0); glVertex2f(x, y);
        glTexCoord2f(1, 0); glVertex2f(x + width, y);
        glTexCoord2f(1, 1); glVertex2f(x + width, y + height);
        glTexCoord2f(0, 1); glVertex2f(x, y + height);
        glEnd();
    }

}
