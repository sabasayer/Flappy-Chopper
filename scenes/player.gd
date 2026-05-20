class_name Player
extends CharacterBody2D

enum PLAYER_STATE {
	Idle,
	Hurt,
	Dying
}

signal player_died()

@export var speed: int = 200
@export var jump_velocity: int = -400
@export var bullet_speed: int = 600
@export var bullet_scene: PackedScene
@export var no_gravity: bool
@export var camera: CameraShakable

@onready var bullet_spawn: Marker2D = $BulletSpawn
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_spark_particles: HurtSparkParticle = $HurtSparkParticles
@onready var hurt_smoke_particles: GPUParticles2D = $HurtSmokeParticles
@onready var shoot_particles: GPUParticles2D = $BulletSpawn/ShootParticle

var player_state:PLAYER_STATE = PLAYER_STATE.Idle

func _ready() -> void:
	assert(bullet_scene != null, "Bullet scene should be assigned")
	var shoot_material := shoot_particles.process_material as ShaderMaterial
	shoot_material.set_shader_parameter("particle_count", shoot_particles.amount)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not no_gravity:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		on_jump(delta)

	# Constant horizontal speedgap_height
	velocity.x = speed

	move_and_slide()

func on_jump(delta: float):
	velocity.y = jump_velocity
	
	var bullet_instance := bullet_scene.instantiate() as Bullet
	bullet_instance.speed = bullet_speed
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = bullet_spawn.global_position
	run_shoot_particles()
	camera.shake(0.2)

func run_shoot_particles() -> void:
	shoot_particles.restart()
	shoot_particles.emitting = true

func get_size():
	return (collision_shape_2d.shape as RectangleShape2D).size

func state_to_hurt(hit_info:HitInfo):
	if player_state != PLAYER_STATE.Idle:
		return
		
	player_state = PLAYER_STATE.Hurt
	run_hurt_animation(hit_info)
	
func run_hurt_animation(hit_info:HitInfo):
	camera.shake()
	flash_animation()
	squash_animation()
	run_hurt_particles(hit_info)
	EffectUtils.freeze_frame(0.06,self)
	
# use the hit info to set the particle material direction to opposite of the 
func run_hurt_particles(hit_info:HitInfo):
	hurt_spark_particles.run_hurt_particles(hit_info)
	
	await get_tree().create_timer(0.05).timeout
	hurt_smoke_particles.restart()
	hurt_smoke_particles.emitting = true
	

func flash_animation():
	animated_sprite_2d.modulate = Color.RED
	var tween = get_tree().create_tween()
	tween.tween_property(animated_sprite_2d,"modulate",Color.WHITE,0.5).set_trans(Tween.TRANS_SINE)
	
func squash_animation():
	animated_sprite_2d.scale = Vector2(0.9, 1)
	var tween = get_tree().create_tween()
	tween.tween_property(animated_sprite_2d,"scale",Vector2.ONE,0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(on_hurt_animation_end)
	
func on_hurt_animation_end():
	player_state = PLAYER_STATE.Idle

func _on_health_component_died() -> void:
	player_died.emit()


func _on_health_component_damaged(hit_info:HitInfo) -> void:
	state_to_hurt(hit_info)
