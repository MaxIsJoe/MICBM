shader_type canvas_item;

// --- Uniforms --- //
uniform vec2 speed = vec2(1.0, 0.0);
uniform float transparency:hint_range(0.0, 1.0, 0.01) = 1.0;

// --- Functions --- //
void fragment() {
	vec4 in_color = texture(TEXTURE, UV);
	float in_alpha = in_color.a;
	COLOR = texture(TEXTURE, mod(UV + TIME * speed, 1.0));
	COLOR.a = transparency;
}