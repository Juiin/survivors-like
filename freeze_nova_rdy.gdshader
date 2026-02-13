shader_type canvas_item;

uniform float intensity : hint_range(0.0, 2.0) = 1.0;
uniform vec4 ice_color : source_color = vec4(0.4, 0.9, 1.0, 1.0);

uniform float flow_speed = 1.5;
uniform float flow_scale = 8.0;
uniform float rim_strength = 1.5;
uniform float shimmer_strength = 0.01;

/* --- simple hash noise --- */
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (vec2(3.0) - 2.0 * f);

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void fragment() {

    vec2 uv = UV;
    vec4 base = texture(TEXTURE, uv);

    // -------- SHIMMER (explicit vec2 math) --------
    vec2 time_offset = vec2(TIME * 2.0, TIME * 1.3);
    vec2 shimmer_uv = uv * 6.0 + time_offset;

    float shimmer = noise(shimmer_uv);

    vec2 distortion = vec2(
        (shimmer - 0.5) * shimmer_strength * intensity,
        (shimmer - 0.5) * shimmer_strength * intensity
    );

    vec2 final_uv = clamp(uv + distortion, vec2(0.0, 0.0), vec2(1.0, 1.0));
    vec4 refracted = texture(TEXTURE, final_uv);

    // -------- INTERNAL FLOW --------
    vec2 flow_offset = vec2(TIME * flow_speed, TIME * flow_speed * 0.4);
    vec2 flow_uv = uv * flow_scale + flow_offset;

    float flow = smoothstep(0.4, 0.7, noise(flow_uv));

    // -------- RIM GLOW --------
    vec2 centered = uv - vec2(0.5, 0.5);
    float dist = length(centered);
    float rim = pow(clamp(1.0 - dist * 2.0, 0.0, 1.0), 2.5);

    // -------- COLOR COMPOSITION --------
    vec3 color = refracted.rgb;

    float tint = clamp(0.6 * intensity, 0.0, 1.0);
    vec3 target = color * 0.7 + ice_color.rgb * 0.3;

    color = mix(color, target, vec3(tint));

    color += ice_color.rgb * flow * 0.8 * intensity;
    color += ice_color.rgb * rim * rim_strength * intensity;

    COLOR = vec4(clamp(color, 0.0, 1.5), base.a);
}
