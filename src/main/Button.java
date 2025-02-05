package main;

import static org.lwjgl.opengl.GL11.*;


public class Button {
    private float x;
    private float y;
    private float width;
    private float height;
    private Texture texture;

    public Button(float x, float y, float width, float height, Texture texture){
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public void onClick(int button, int action, int mods){
        if(button == 0 && action == 1){
            System.out.println("Button clicked");
        }
    }

    public void render(){
        texture.bind();
        glBegin(GL_QUADS);
        glVertex2f(x, y);
        glVertex2f(x + width, y);
        glVertex2f(x + width, y + height);
        glVertex2f(x, y + height);
        glEnd();
        texture.unbind();

    }
}
