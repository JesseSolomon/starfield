out vec2 screenPosition;

void main() {
	vec4 finalPosition = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1.0);

	screenPosition = vec2(finalPosition.xyz / finalPosition.w);

	gl_Position = finalPosition;
}