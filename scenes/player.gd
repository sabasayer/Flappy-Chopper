class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	# Constant horizontal speed
	velocity.x = SPEED

	move_and_slide()

func on_collision_with_pipe(pipe:Pipe) -> void:
	print("collision with pipe", pipe)