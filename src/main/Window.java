package main;

import static org.lwjgl.glfw.GLFW.*;
import static org.lwjgl.opengl.GL.*;
import static org.lwjgl.opengl.GL11.*;


import java.nio.ByteBuffer;

import org.lwjgl.glfw.GLFWImage;

public class Window {
    private long id;

    public Window(int width, int height, String title){
        if(!glfwInit()){
            throw new IllegalStateException("Unable to initialize GLFW");
        }

        glfwWindowHint(GLFW_VISIBLE, GLFW_FALSE);
        id = glfwCreateWindow(width, height, title, 0, 0);
        if(id == 0){
            throw new IllegalStateException("Failed to create window");
        }

        glfwMakeContextCurrent(id);
        createCapabilities();
        glfwShowWindow(id);

        glEnable(GL_TEXTURE_2D);

        glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrtho(-width/2, width/2, height/2, -height/2, 1, -1);
        glMatrixMode(GL_MODELVIEW);

        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        //disable resampling
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

        //disable resizing
        glfwSetWindowSizeLimits(id, width, height, width, height);

        
        
    }

    public void loop(){



        Texture boykisser = new Texture("/res/boykisser.png");


        Plane plane = new Plane(0, 0, 128, 128);

        Shader boykisserShader = new Shader("/res/boykisser.vert", "/res/boykisser.frag");

        long lastTime = System.nanoTime();
        final double nsPerFrame = 1000000000.0 / 20.0;

        double delta = 0;
        while(!glfwWindowShouldClose(id)){
            long now = System.nanoTime();
            delta += (now - lastTime) / nsPerFrame;
            lastTime = now;

            while (delta >= 1) {
                glClear(GL_COLOR_BUFFER_BIT);

                boykisserShader.bind();
                boykisserShader.setUniform("t", (float) glfwGetTime());
                Background.draw();
                boykisserShader.unbind();

                plane.render();

                glfwSwapBuffers(id);
                glfwPollEvents();

                delta--;
            }
        }
    }

    public void exit(){
        glfwDestroyWindow(id);
        glfwTerminate();
    }

    public void setIcon(String path){
        ByteBuffer icon = Texture.loadIcon(path);
        GLFWImage image = GLFWImage.malloc();
        image.set(512, 512, icon);
        GLFWImage.Buffer images = GLFWImage.malloc(1);
        images.put(0, image);
        glfwSetWindowIcon(id, images);
    }
}
