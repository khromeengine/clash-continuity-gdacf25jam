shader_type canvas_item;

uniform vec3 laser_color : source_color;
instance uniform float opacity = 1.0;
instance uniform bool warbling = false;
uniform float warbling_speed = 1.0;

void fragment() {
	if (COLOR.a > 0.0) {
		if (warbling) {
			COLOR.rgb = laser_color + abs(sin(warbling_speed * vec3(1.0) * TIME));
		} else {
			COLOR.rgb = laser_color;
		}
		COLOR.a = 1.0 - pow(UV.x, 0.5);
		COLOR.a *= opacity;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
