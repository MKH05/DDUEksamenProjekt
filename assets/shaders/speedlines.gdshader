shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform sampler2D noise;
uniform float sample_radius: hint_range(0.0, 1.0) = 0.5;
uniform vec4 line_color: source_color = vec4(1.0);
uniform float center_radius: hint_range(0.0, 1.0) = 0.5;

const float pi = 3.14159265359;

void fragment() {
    vec2 dist = UV - center;
    float angle = atan(dist.y, dist.x); // Fix atan to use two parameters for correct quadrant detection

    // Introduce randomness using TIME
    float time_offset = fract(sin(TIME * 0.5) * 43758.5453);
    vec2 sample = vec2(
        (sample_radius + time_offset * 0.2) * cos(angle + time_offset * 2.0),
        (sample_radius + time_offset * 0.2) * sin(angle + time_offset * 2.0)
    );

    float noise_value = texture(noise, sample).r;

    // Create the speed lines effect
    vec4 color = mix(line_color, vec4(0.0), noise_value);
    color = mix(color, vec4(0.0), 1.0 - length(dist) - center_radius);

    COLOR = color;
}
