package main;

import java.awt.image.BufferedImage;
import java.io.InputStream;
import java.nio.ByteBuffer;

import javax.imageio.ImageIO;

import org.lwjgl.BufferUtils;

import static org.lwjgl.opengl.GL11.*;
import static org.lwjgl.opengl.GL30.*;


public class Texture {
    private int id;

    public Texture(String path){
        BufferedImage bi;
        try(InputStream is = getClass().getResourceAsStream(path)){
            bi = ImageIO.read(is);
            int w = bi.getWidth();
            int h = bi.getHeight();
            int[] pixels = new int[w * h];
            bi.getRGB(0, 0, w, h, pixels, 0, w);
            id = glGenTextures();
            glBindTexture(GL_TEXTURE_2D, id);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_BGRA, w, h, 0, GL_BGRA, GL_UNSIGNED_BYTE, pixels);
            glGenerateMipmap(GL_TEXTURE_2D);
        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }

    public void bind(){
        glBindTexture(GL_TEXTURE_2D, id);
    }

    public void unbind(){
        glBindTexture(GL_TEXTURE_2D, 0);
    }

    public static ByteBuffer loadIcon(String path){
        BufferedImage bi;
        try(InputStream is = Texture.class.getResourceAsStream(path)){
            bi = ImageIO.read(is);
            int w = bi.getWidth();
            int h = bi.getHeight();
            int[] pixels = new int[w * h];
            bi.getRGB(0, 0, w, h, pixels, 0, w);
            ByteBuffer buffer = BufferUtils.createByteBuffer(w * h * 4);
            for(int y = 0; y < h; y++){
                for(int x = 0; x < w; x++){
                    int pixel = pixels[y * w + x];
                    buffer.put((byte)((pixel >> 16) & 0xFF));
                    buffer.put((byte)((pixel >> 8) & 0xFF));
                    buffer.put((byte)(pixel & 0xFF));
                    buffer.put((byte)((pixel >> 24) & 0xFF));
                }
            }
            buffer.flip();
            return buffer;
        } catch(Exception e){
            throw new RuntimeException(e);
        }
    }
}
