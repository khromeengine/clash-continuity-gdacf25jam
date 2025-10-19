shader_type canvas_item;

uniform vec3 laser_color : source_color;

void fragment() {
	if (COLOR.a > 0.0) {
		COLOR.rgb = laser_color;
		COLOR.a = 1.0 - pow(UV.x, 0.5);
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
