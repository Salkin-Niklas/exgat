shader_type canvas_item;

uniform sampler2D iChannel0 : hint_screen_texture, repeat_disable, filter_nearest;

void fragment()
{
	vec2 resolution = 1./SCREEN_PIXEL_SIZE;
	vec2 amount = resolution/3.;
    vec2 lookup_pos = round(UV*amount)/amount;
	COLOR = texture(iChannel0, lookup_pos);
}