shader_type spatial;
uniform sampler2D noise;
uniform float size;


void vertex() {
  float height = texture(noise, VERTEX.xz / 0.1).r;
  float width = texture(noise, VERTEX.xz / 0.1).g;

  VERTEX.y *= height * size;
  VERTEX.x *= width * size;

}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 color = vec3(0.0, 0.0, 1.0);
	ALBEDO = color;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
