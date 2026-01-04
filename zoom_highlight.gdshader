shader_type canvas_item;

// ** Nested Tinted Zooms **
// Displays expanding nested tinted copies of <sample> behind a Sprite2D.texture

uniform sampler2D sample;                // The image being duplicated
uniform float speed = 1.0;               // Cycles per second
uniform float max_zoom = 2.0;             // Scale of max zoom
uniform int layer_count = 3;              // Count of duplicates of <sample> to display
uniform int color_count = 3;              // Count of colors to cycle through
uniform vec2 pivot = vec2(0.5, 0.5);      // Point duplicates zoom from [0.0, 1.0]
uniform bool is_only_bigger = true;        // Should duplicates start at zoom = 1.0?
uniform bool is_show_original = true;      // Show original sprite
uniform bool is_use_colors = true;         // If false, layers use original colors
uniform float boarder_zoom = 2.0;          // Canvas size of texture
uniform float contrast_offset : hint_range(0.0, 1.0, 0.1) = 0.1;
uniform vec3 color_array[9];               // Tint colors

// NEW: global alpha control
uniform float alpha_multiplier : hint_range(0.0, 1.0, 0.01) = 1.0;


// Expands extents to match <boarder_zoom> and centers (0, 0) at (0.5, 0.5)
void vertex() {
    vec2 center_dist = vec2(0.5, 0.5) - VERTEX;
    center_dist *= boarder_zoom;
    VERTEX = vec2(0.5, 0.5) - center_dist;
}


// UV bounds check
bool is_uv_outofbounds(vec2 a_uv) {
    return a_uv.x > 1.0 || a_uv.x < 0.0 || a_uv.y > 1.0 || a_uv.y < 0.0;
}


// Adjust UV per scale and pivot
vec2 adj_uv(vec2 a_uv, float a_scale, vec2 a_pivot) {
    return a_pivot + (a_uv - a_pivot) * pow(a_scale, -1.0);
}


// Normalized looping float [0, 0.999]
float normalized_float(float a_float) {
    return float(int(10000.0 * a_float) % 10000) / 10000.0;
}


// Looping time value
float time_delta() {
    return normalized_float(TIME * speed);
}


// Slower looping time for color cycling
float layer_time_delta() {
    return normalized_float(TIME * speed / float(layer_count));
}


// Converts color to greyscale, then tints
vec3 tinted_color(vec3 a_color, vec3 a_tint) {
    float t_average = (a_color.r + a_color.g + a_color.b) / 3.0;
    t_average *= (1.0 - contrast_offset);
    t_average += contrast_offset;
    return a_tint * t_average;
}


// Determines when layer and layer color match
int color_index(int a_index) {
    int t_layer_index = int(float(layer_count) * layer_time_delta());
    return abs(t_layer_index - a_index) % layer_count;
}


// Main fragment logic
void fragment() {

    // Draw original sprite
    if (is_show_original) {
        COLOR = texture(
            TEXTURE,
            adj_uv(UV, pow(boarder_zoom, -1.0), vec2(0.5))
        );
        COLOR.a *= alpha_multiplier;
    } else {
        COLOR = vec4(0.0);
    }

    // Only draw layers where original is transparent
    if (COLOR.a == 0.0) {

        float scale_fraction = is_only_bigger
            ? (max_zoom - 1.0) / float(layer_count)
            : max_zoom / float(layer_count);

        for (int i = layer_count - 1; i >= 0; i--) {

            float size_scale = scale_fraction * (float(i) + time_delta());
            if (is_only_bigger) {
                size_scale += 1.0;
            }

            vec2 adjusted_uv = adj_uv(
                adj_uv(UV, pow(boarder_zoom, -1.0), vec2(0.5)),
                size_scale,
                pivot
            );

            vec4 t_color = is_uv_outofbounds(adjusted_uv)
                ? vec4(0.0)
                : texture(sample, adjusted_uv);

            if (t_color.a > 0.0) {

                // Alpha falloff + global alpha
                float layer_alpha =
                    pow(1.0 - (size_scale / max_zoom), 0.7);

                t_color.a *= layer_alpha * alpha_multiplier;

                vec3 t_tint = t_color.rgb;

                if (is_use_colors) {
                    for (int j = 0; j < layer_count; j++) {
                        if (color_index(i + j) == 0 && j < color_array.length()) {
                            t_tint = tinted_color(t_color.rgb, color_array[j % color_count]);
                        }
                    }
                }

                COLOR = vec4(t_tint, t_color.a);
            }
        }
    }
}
