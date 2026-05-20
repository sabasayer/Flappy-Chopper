shader_type particles;

uniform float fan_half_angle_deg : hint_range(0.0, 90.0, 0.1) = 45.0;
uniform float speed : hint_range(0.0, 1000.0, 1.0) = 200.0;
uniform float spawn_half_height : hint_range(0.0, 64.0, 0.5) = 6.0;
uniform float particle_scale : hint_range(0.0, 1.0, 0.001) = 0.055;
uniform int particle_count : hint_range(1, 32) = 4;
uniform float spawn_jitter : hint_range(0.0, 32.0, 0.1) = 2.5;
uniform float angle_jitter_deg : hint_range(0.0, 45.0, 0.1) = 14.0;
uniform float speed_jitter : hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float scale_jitter : hint_range(0.0, 1.0, 0.01) = 0.25;

float rand_from_seed(inout uint seed) {
	seed = (seed << 13u) ^ (seed >> 19u) ^ (seed << 5u);
	return fract(float(seed) / 4294967295.0);
}

void start() {
	uint seed = INDEX ^ (NUMBER * 7919u) ^ RANDOM_SEED;

	float denom = max(float(particle_count) - 1.0, 1.0);
	float t = (float(INDEX) / denom) * 2.0 - 1.0;
	float emit_y = t * spawn_half_height + (rand_from_seed(seed) - 0.5) * spawn_jitter * 2.0;

	float spread_rad = fan_half_angle_deg * (PI / 180.0);
	float angle_jitter_rad = angle_jitter_deg * (PI / 180.0);
	float move_angle = PI - t * spread_rad + (rand_from_seed(seed) - 0.5) * angle_jitter_rad * 2.0;
	vec2 dir = vec2(cos(move_angle), sin(move_angle));

	float particle_speed = speed * (1.0 + (rand_from_seed(seed) - 0.5) * speed_jitter * 2.0);
	VELOCITY = vec3(dir * particle_speed, 0.0);

	float scale = particle_scale * (1.0 + (rand_from_seed(seed) - 0.5) * scale_jitter * 2.0);
	float rot = move_angle + PI * 0.5;
	mat2 basis = mat2(vec2(cos(rot), sin(rot)), vec2(-sin(rot), cos(rot))) * scale;

	TRANSFORM = mat4(1.0);
	TRANSFORM[0] = vec4(basis[0], 0.0, 0.0);
	TRANSFORM[1] = vec4(basis[1], 0.0, 0.0);
	TRANSFORM[3] = vec4(0.0, emit_y, 0.0, 1.0);

	COLOR = vec4(1.0);
}

void process() {
	TRANSFORM[3].xyz += VELOCITY * DELTA;
}
