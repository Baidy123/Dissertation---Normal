shader_type canvas_item;

uniform float filled_percent : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR.a *= step(1.0 - filled_percent, UV.y * 1.18 -0.1);
}
