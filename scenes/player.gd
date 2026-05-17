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

@onready var bullet_spawn: Marker2D = $BulletSpawn
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var player_state:PLAYER_STATE = PLAYER_STATE.Idle

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
	velocity.x = speed

	move_and_slide()

func on_jump(delta: float):
	velocity.y = jump_velocity
	
	var bullet_instance := bullet_scene.instantiate() as Bullet
	bullet_instance.speed = bullet_speed
	bullet_instance.global_position = bullet_spawn.global_position
	get_tree().current_scene.add_child(bullet_instance)
	
func get_size():
	return (collision_shape_2d.shape as RectangleShape2D).size

func state_to_hurt():
	if player_state != PLAYER_STATE.Idle:
		return
		
	player_state = PLAYER_STATE.Hurt
	run_hurt_animation()
	
func run_hurt_animation():
	pass

func _on_health_component_died() -> void:
	player_died.emit()


func _on_health_component_damaged(amount: int) -> void:
	pass # Replace with function body.
