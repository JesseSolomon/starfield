in vec2 screenPosition;

uniform float aspect;
uniform float time;
uniform vec2 mouse;

#define STAR_SPEED 0.5
#define STAR_DENSITY 250.0
#define MOUSE_SCALE 0.25

// A slight adaptation of these smart folks work: https://thebookofshaders.com/10/
float random(float st) {
	return fract(sin(dot(st, 12.9898)) * 43758.5453123);
}

void main() {
	vec3 color;

	// Calculates the "star column"
	// Imagine the screen broken up into slices like a pie, this formula finds out which slice the current pixel is in
	vec2 direction = normalize(floor(normalize(screenPosition - mouse * MOUSE_SCALE) * STAR_DENSITY) / STAR_DENSITY);

	// The offset to be applied to the star
	float offset = random(direction.x + direction.y * 10.0) / STAR_SPEED;

	// The distance the star is from the center point
	float scale = mod(time * STAR_SPEED * offset + offset, 1.414214);

	// Get the distance of the current pixel from the center, if it's near enough to the star's, then we draw it
	if (distance(distance(screenPosition, mouse * 0.25), scale) < 0.001) {
		// Gets the linearized distance from the pixel to the center
		float centerDistance = clamp(length((screenPosition - mouse * MOUSE_SCALE) * vec2(aspect, 1)), 0.0, 1.0);

		// Create a fun space-y color from our position
		color = vec3(abs(direction) * 2.0, 1.0) * clamp(centerDistance / 0.3, 0.0, 1.0);
	}

	gl_FragColor = vec4(color, 1);
}
