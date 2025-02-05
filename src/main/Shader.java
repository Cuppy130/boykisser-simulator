package main;

import static org.lwjgl.opengl.GL20.*;

public class Shader {
    private int program;
    private int vertexShader;
    private int fragmentShader;

    public Shader(String vertPath, String fragPath) {
        program = glCreateProgram();
        vertexShader = glCreateShader(GL_VERTEX_SHADER);
        fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);

        String vertSource = Utils.loadAsString(vertPath);
        String fragSource = Utils.loadAsString(fragPath);

        glShaderSource(vertexShader, vertSource);
        glCompileShader(vertexShader);
        if(glGetShaderi(vertexShader, GL_COMPILE_STATUS) == GL_FALSE){
            throw new IllegalStateException("Failed to compile vertex shader: " + glGetShaderInfoLog(vertexShader));
        }

        glShaderSource(fragmentShader, fragSource);
        glCompileShader(fragmentShader);
        if(glGetShaderi(fragmentShader, GL_COMPILE_STATUS) == GL_FALSE){
            throw new IllegalStateException("Failed to compile fragment shader: " + glGetShaderInfoLog(fragmentShader));
        }

        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);

        glLinkProgram(program);
        if(glGetProgrami(program, GL_LINK_STATUS) == GL_FALSE){
            throw new IllegalStateException("Failed to link program: " + glGetProgramInfoLog(program));
        }

        glValidateProgram(program);
        if(glGetProgrami(program, GL_VALIDATE_STATUS) == GL_FALSE){
            throw new IllegalStateException("Failed to validate program: " + glGetProgramInfoLog(program));
        }
    }

    public void bind(){
        glUseProgram(program);
    }

    public void unbind(){
        glUseProgram(0);
    }

    public void setUniform(String name, float value){
        int location = glGetUniformLocation(program, name);
        if(location != -1){
            glUniform1f(location, value);
        }
    }

    public void cleanup(){
        glDetachShader(program, vertexShader);
        glDetachShader(program, fragmentShader);
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        glDeleteProgram(program);
    }

    public int getProgram() {
        return program;
    }


}
