shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0);
uniform vec4 blink_color : source_color = vec4(1.0);
uniform float blink_time_scale : hint_range(0.0, 10.0, 0.1) = 0.0;

uniform vec4 hit_flash_color : source_color = vec4(1.0);
uniform bool hit_flash_on = false;

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;

	// Detect if pixel is opaque
	bool opaque = sprite_color.a > 0.0;

	// Detect if any surrounding pixel is transparent (edge detection)
	bool near_transparent = false;
	near_transparent = near_transparent || texture(TEXTURE, UV + pixel_size * vec2(1.0, 0.0)).a == 0.0;
	near_transparent = near_transparent || texture(TEXTURE, UV + pixel_size * vec2(-1.0, 0.0)).a == 0.0;
	near_transparent = near_transparent || texture(TEXTURE, UV + pixel_size * vec2(0.0, 1.0)).a == 0.0;
	near_transparent = near_transparent || texture(TEXTURE, UV + pixel_size * vec2(0.0, -1.0)).a == 0.0;
	//near_transparent = near_transparent || texture(TEXTURE, UV + pixel_size * vec2(1.0, 1.0)).a == 0.0;
	//near_transparent = near_transparent || texture(TEXTURE, UV + pixel_size * vec2(1.0, -1.0)).a == 0.0;
	//near_transparent = near_transparent || texture(TEXTURE, UV + pixel_size * vec2(-1.0, 1.0)).a == 0.0;
	//near_transparent = near_transparent || texture(TEXTURE, UV + pixel_size * vec2(-1.0, -1.0)).a == 0.0;

	// Inner outline pixels are the opaque ones next to transparency
	bool inner_outline = opaque && near_transparent;

	// Base sprite color
	vec4 base_color = sprite_color * COLOR;

	// Blink effect only for inner outline
	float blink_t = 0.5 - 0.5 * cos(TIME * blink_time_scale); // oscillates between 0 and 1
	vec4 outline_blink_color = mix(base_color, outline_color * blink_color, blink_t);

	vec4 final_color = base_color;
	final_color = mix(final_color, outline_blink_color, float(inner_outline));

	// Optional hit flash
	if (hit_flash_on) {
		final_color = vec4(hit_flash_color.rgb, sprite_color.a);
	}

	COLOR = final_color;
}
