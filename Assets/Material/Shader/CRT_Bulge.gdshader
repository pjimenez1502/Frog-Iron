shader_type canvas_item;
uniform float intensity: hint_range(-1.0, 1.0, 0.001) = 0.065;

uniform sampler2D ST : filter_nearest;

void fragment() {
	float map = distance(UV, vec2(0.5));
	COLOR = texture(ST, vec2(
		UV.x - (map - 0.5) * intensity * (0.5 - UV.x),
		UV.y - (map - 0.5) * intensity * (0.5 - UV.y))
	);
}
