class_name Player
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

signal player_died()

@export var bullet_speed: int = 600
@export var bullet_scene: PackedScene
@export var no_gravity: bool

@onready var bullet_spawn: Marker2D = $BulletSpawn
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	assert(bullet_scene != null, "Bullet scene should be assigned")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not no_gravity:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		on_jump(delta)

	# Constant horizontal speedgap_height
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
	
func get_size():
	return (collision_shape_2d.shape as RectangleShape2D).size
