class_name HurtSparkParticle extends GPUParticles2D

func run_hurt_particles(hit_info:HitInfo):
	var particle_material = (process_material as ParticleProcessMaterial)
	particle_material.direction = Vector3(hit_info.direction.x, hit_info.direction.y, 0)
	const offset = 10
	particle_material.emission_shape_offset = Vector3(hit_info.direction.x * offset, hit_info.direction.y * offset, 0)
	restart()
	emitting = true
