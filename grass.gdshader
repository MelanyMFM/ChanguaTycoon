shader_type spatial;
uniform vec3 color: source_color;
uniform vec3 color2: source_color;
uniform sampler2D noise;
uniform float noiseScale = 20.0;
render_mode cull_disabled;

varying vec3 worldPos;


void vertex() {
	worldPos = (MODEL_MATRIX * vec4 (VERTEX, 1.0)).xyz;
}

void fragment() {
	vec3 noiseLevel = texture(noise, worldPos.xz / noiseScale).rgb;
	ALBEDO = mix(color, color2, UV.y);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
