shader_type canvas_item;

instance uniform vec4 outline_color : source_color;
uniform float outline_width = 1.0;
uniform float blend : hint_range(0,1);

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;
	bool is_in_outline = texture(TEXTURE, UV - vec2(outline_width, 0.0) * pixel_size).a > 0.0;
	is_in_outline = is_in_outline || texture(TEXTURE, UV - vec2(0.0, outline_width) * pixel_size).a > 0.0;
	is_in_outline = is_in_outline || texture(TEXTURE, UV - vec2(-outline_width, 0.0) * pixel_size).a > 0.0;
	is_in_outline = is_in_outline || texture(TEXTURE, UV - vec2(0.0, -outline_width) * pixel_size).a > 0.0;
	is_in_outline = is_in_outline || texture(TEXTURE, UV - round(vec2(-outline_width / 2.0, -outline_width / 2.0)) * pixel_size).a > 0.0;
	is_in_outline = is_in_outline || texture(TEXTURE, UV - round(vec2(outline_width / 2.0, -outline_width / 2.0)) * pixel_size).a > 0.0;
	is_in_outline = is_in_outline || texture(TEXTURE, UV - round(vec2(-outline_width / 2.0, outline_width / 2.0)) * pixel_size).a > 0.0;
	is_in_outline = is_in_outline || texture(TEXTURE, UV - round(vec2(outline_width / 2.0, outline_width / 2.0)) * pixel_size).a > 0.0;
	if (is_in_outline && texture(TEXTURE, UV).a == 0.0) {
		COLOR = mix(COLOR, outline_color, blend);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
