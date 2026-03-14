class_name Player
extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -400.0

signal player_died()

@export var bullet_speed: int = 600
@export var bullet_scene: PackedScene

@onready var bullet_spawn: Marker2D = $BulletSpawn

func _ready() -> void:
	assert(bullet_scene != null, "Bullet scene should be assigned")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		on_jump(delta)

	# Constant horizontal speed
	velocity.x = SPEED

	move_and_slide()

func on_collision_with_pipe(pipe:Pipe) -> void:
	print("collision with pipe", pipe)
	player_died.emit()

func on_jump(delta: float):
	velocity.y = JUMP_VELOCITY
	
	var bullet_instance := bullet_scene.instantiate() as Bullet
	bullet_instance.speed = bullet_speed
	bullet_instance.global_position = bullet_spawn.global_position
	get_tree().current_scene.add_child(bullet_instance)
	
