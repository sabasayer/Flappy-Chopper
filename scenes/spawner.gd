class_name Spawner extends Node2D

enum SpawnType {
	PIPE,
	PIPE_WITH_ENEMY,
	ENEMY_ONLY
}

@export var pipe_pair_scene: PackedScene = preload("res://scenes/pipe-pair.tscn")
@export var pipes_container: Node2D
@export var min_spawn_distance: int = 150
@export var max_spawn_distance: int = 500

@export var next_spawn_x: int = 400
@export var spawn_margin: int = 100

var player: Player:
	get():
		return get_tree().get_first_node_in_group("player") as Player
	
var camera: Camera2D:
	get():
		return get_viewport().get_camera_2d()
	
func check_and_spawn():
	print("start checking")
	var screen_width = get_viewport_rect().size.x
	var visible_right = camera.global_position.x + screen_width / 2 
	while visible_right + spawn_margin > next_spawn_x:
		print("spawning")
		next_spawn_x += randi_range(min_spawn_distance,max_spawn_distance)
		spawn(next_spawn_x)

func spawn(position: int):
	print("spawn to:" ,position)
	var pipe_pair = pipe_pair_scene.instantiate() as PipePair
	pipe_pair.global_position.x = position
	pipes_container.add_child(pipe_pair)
	
