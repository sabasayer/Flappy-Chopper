class_name SpawnerBase extends Node2D

@export var next_spawn_x: int = 200
@export var spawn_y_diff: int = 30
@export var spawn_margin: int = 400
@export var spawn_distance_min: int = 200
@export var spawn_distance_max: int = 350
@export var container: Node2D

var player: Player:
	get():
		return get_tree().get_first_node_in_group("player") as Player
		
var player_distance: float:
	get():
		return player.global_position.x
	
var camera: Camera2D:
	get():
		return get_viewport().get_camera_2d() 
	
var screen_width: float:
	get():
		return get_viewport_rect().size.x
		
func _process(_delta: float) -> void:
	check_and_spawn()

func check_and_spawn():
	var visible_right = camera.global_position.x + screen_width / 2
	while visible_right + spawn_margin > next_spawn_x:
		print("spawning")
		next_spawn_x += randi_range(spawn_distance_min, spawn_distance_max)
		spawn(next_spawn_x)
		
func spawn(pos:int):
	var index = randi_range(0,get_child_count()-1)
	var child = get_child(index)
	if not child:
		return
		
	var clone = child.duplicate() as Sprite2D
	clone.global_position.x = pos
	
	var spawn_y = randf_range(0, spawn_y_diff)
	clone.global_position.y = spawn_y
	container.add_child(clone)
	var width = clone.get_rect().size.x
	width = width * clone.scale.x
	next_spawn_x += width
