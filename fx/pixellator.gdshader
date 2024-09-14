shader_type canvas_item;

uniform sampler2D lut;
uniform float lut_size = 16;
uniform float dither_power = 0.01;
uniform float dither_scale = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
	float sqrtsize = sqrt(lut_size);
	float isqrtsize = 1.0 / sqrtsize;
	
	vec2 pixel_position = floor(SCREEN_UV / SCREEN_PIXEL_SIZE / dither_scale);
	vec4 original_colour = texture( SCREEN_TEXTURE, SCREEN_UV );
	
	// Dithering stuff
	bool even_x = fract(pixel_position.x / 2.0) == 0.0;
	if (even_x) { original_colour.r += dither_power; }
	else { original_colour.r -= dither_power; }
	
	bool even_y = fract(pixel_position.x / 2.0) == 0.0;
	if (even_y) { original_colour.g += dither_power; }
	else { original_colour.g -= dither_power; }
	
	bool even = fract((pixel_position.x + pixel_position.y) / 2.0) == 0.0;
	if (even) { original_colour.b += dither_power; }
	else { original_colour.b -= dither_power; }
	
	// Dunno why this is here
	original_colour *= 0.995;
	
	vec2 target = vec2(0.0, 0.0);
	target.x = floor( original_colour.r * lut_size ) / (lut_size * sqrtsize);
	target.y = floor( original_colour.g * lut_size ) / (lut_size * sqrtsize);
	
	float b_index = floor( original_colour.b * lut_size );
	float bx = mod( b_index, sqrtsize );
	float by = floor( b_index / sqrtsize );
	
	target.x += bx / sqrtsize;
	target.y += by / sqrtsize;
	
	COLOR = texture( lut, target );
}


