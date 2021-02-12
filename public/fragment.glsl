in vec2 screenPosition;

uniform float aspect;
uniform float time;
uniform vec2 mouse;

#define STAR_SPEED 0.5
#define STAR_DENSITY 250.0

// I'm terrible at math, so this is a rough adaptation of these smart folks work: https://thebookofshaders.com/10/
float random(float st) {
	return fract(sin(dot(st, 12.9898)) * 43758.5453123);
}

void main() {
	vec3 color;

	vec2 direction = normalize(floor(normalize(screenPosition - mouse * 0.25) * STAR_DENSITY) / STAR_DENSITY);

	float offset = random(direction.x + direction.y * 10.0) / STAR_SPEED;

	float scale = mod(time * STAR_SPEED * offset + offset, 1.414214);

	// float dist = distance(screenPosition, mouse);
	// color =  distance(screenPosition, mouse) < scale ? vec3(1.0, 1.0, 1.0) : vec3(0, 0, 0);
	if (distance(distance(screenPosition, mouse * 0.25), scale) < 0.001) {
		float centerDistance = clamp(length((screenPosition - mouse * 0.25) * vec2(aspect, 1)), 0.0, 1.0);

		// color = vec3(1, 1, 1);
		color = vec3(abs(direction) * 2.0, 1.0) * clamp(centerDistance / 0.3, 0.0, 1.0);
	}

	// for (int i = 0; i < STAR_COUNT; i++) {
	// 	// Pick a random direction for the star to travel in
	// 	vec2 direction = normalize(vec2((randomA(float(i)) - 0.5) * 2.0, (randomB(float(i)) - 0.5) * 2.0));

	// 	// A random offset for each star so they don't all start at the same time
	// 	float offset = randomB(float(i + 1)) * 1.414214;

	// 	// Get the scale of the point, if the scale exceeds the viewport, wrap it back around to 0
	// 	float scale = mod(length(direction * (time * STAR_SPEED + offset)), 1.414214);

	// 	// Set's the stars position. The mouse effects the offset less if it's further away.
	// 	vec2 star = direction * scale + mouse * scale * 0.25;

	// 	if (distance(screenPosition, star) < 0.001) {
	// 		float centerDistance = clamp(length(vec2(screenPosition.x * aspect, screenPosition.y)), 0.0, 1.0);

	// 		color = vec3(abs(direction) * 2.0, 1.0) * clamp(centerDistance / 0.3, 0.0, 1.0);
	// 		break;
	// 	}
	// }

	gl_FragColor = vec4(color, 1);
}