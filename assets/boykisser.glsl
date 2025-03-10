extern vec2 resolution;
extern float time;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 uv = texture_coords;
    color = Texel(tex, uv);
    color = vec4(color.r, color.g, color.b, 1.0);
    
    return color;
}