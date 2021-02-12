function app(shaders) {
	const scene = new THREE.Scene();
	const camera = new THREE.PerspectiveCamera(75, innerWidth / innerHeight, 0.1, 10);
	const renderer = new THREE.WebGLRenderer();

	renderer.setSize(innerWidth, innerHeight);
	document.body.appendChild(renderer.domElement);

	addEventListener("resize", () => {
		renderer.setSize(innerWidth, innerHeight);
		camera.aspect = innerWidth / innerHeight;
	});

	// Create a plane with a width and height matching the cameras aspect ratio
	// Add a custom shader material with our shaders applied
	const plane = new THREE.Mesh(new THREE.PlaneGeometry(camera.aspect, 1), new THREE.ShaderMaterial({
		vertexShader: shaders[0],
		fragmentShader: shaders[1],
		uniforms: {
			aspect: { value: camera.aspect },
			time: { value: performance.now() / 1000 },
			mouse: { value: new THREE.Vector2(0, 0) }
		}
	}));

	renderer.domElement.addEventListener("mousemove", event => {
		plane.material.uniforms.mouse.value = new THREE.Vector2((1 - event.clientX / innerWidth - 0.5) * 2, (event.clientY / innerHeight - 0.5) * 2);
	});

	// Place the plane in front of the camera to render the whole screen
	camera.position.set(0, 0, 0);
	plane.position.set(0, 0, -camera.near);
	plane.lookAt(camera.position);

	scene.add(plane);

	function render() {
		plane.material.uniforms.aspect.value = camera.aspect;
		plane.material.uniforms.time.value = performance.now() / 1000;

		renderer.render(scene, camera);

		requestAnimationFrame(render);
	}

	requestAnimationFrame(render);
}

Promise.all([ fetch("/vertex.glsl"), fetch("/fragment.glsl") ]) // fetch both the shaders
.then(requests => Promise.all(requests.map(request => request.text()))) // convert the fetch responses to strings
.then(app);