#version 100

precision mediump float;

//allow a texture to be passed in to the shader
uniform sampler2D u_texture;

//time
uniform float t;

//the texture coordinates passed in from the vertex shader
varying vec2 v_texCoord;

void main() {
    vec2 uv = v_texCoord;

    //pixelate
    uv.x = floor(uv.x*256.0)/256.0;
    uv.y = floor(uv.y*256.0)/256.0;

    uv*=7.5;
    uv.y*=-1.;

    uv.x += mod(t, 1.0);
    uv.y += sin(t);
    


    
    //get the color of the texture at the specified UV
    vec4 color = texture2D(u_texture, uv);
    color.a = 0.75;
    gl_FragColor = color;
}