shader_type canvas_item;

/** Noise used for the glitter shape.
* One more irregular glitter option is to use FastNoiseLite -> PerlinNoise with Domain Wrap enabled works nice.
* For a more rounded glitter FastNoiseLite -> PerlinNoise without Domain Wrap without any Fractal Octave.
*/
uniform sampler2D noise_texture;

// Glitter properties
uniform vec4 glitter_color : source_color = vec4(1.0,1.0,0.5,1.0);
uniform float glitter_size: hint_range(0.0, 1.0, 0.01) = 0.05;

/** Glitter highlight speed. */
uniform float glitter_spark_frequency = 100.0;
/** Glitter highlight intensity. */
uniform float glitter_highlight_intensity: hint_range(0.0, 1.0, 0.05) = 0.25;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float glitter_highlight_map = (
		(
			sin((UV.x + UV.y) * 5.0 + TIME * glitter_spark_frequency) * 0.5 + 1.0
		));

	// Generate glitter shapes
	float glitter = (
		// Filter the noise to get the glitter shapes
		smoothstep(
			(1.0 - glitter_size),
			1.0,
			texture(noise_texture, UV).r
			)
		// Apply the highlight map on the glitter.
		* (1.0 - (glitter_highlight_map * clamp(glitter_highlight_intensity,0.0,0.65)))
		);

	// Get the Sprite texture
	vec4 sprite_texture = texture(TEXTURE, UV);

	COLOR = mix(sprite_texture, glitter_color, glitter * sprite_texture.a);

	// This is for debug. Uncommenting this will show the Glitter Highlight Map
	//COLOR = vec4(vec3(glitter_highlight_map),1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
