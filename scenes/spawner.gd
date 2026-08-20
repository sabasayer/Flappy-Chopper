class_name Spawner extends Node2D


@export var pipe_pair_scene: PackedScene = preload("res://scenes/pipe-pair.tscn")
@export var enemy_scene: PackedScene = preload("res://scenes/enemy-scene.tscn")
@export var pipes_container: Node2D
@export var enemy_container: Node2D
@export var next_spawn_x: int = 400
@export var spawn_margin: int = 400
@export var min_distance_for_enemy_spawn: int = 1000

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

var screen_height: float:
	get():
		return get_viewport_rect().size.y
		
func _process(delta: float) -> void:
	check_and_spawn()

func check_and_spawn():
	var visible_right = camera.global_position.x + screen_width / 2
	var spawn_information = get_spawn_info()
	
	while visible_right + spawn_margin > next_spawn_x:
		print("spawning")
		next_spawn_x += spawn_information.pipe_pair_distance
		spawn(next_spawn_x)

func get_spawn_info():
	var spawn_information = DifficultyManager.get_next_spawn_information()
	if !spawn_information:
		print("no spawn information found for distance:", player_distance)
		return
	return spawn_information
		
func spawn(position: int):
	print("spawn to:" ,position)
	
	var spawn_information = get_spawn_info()
	var pipe_gap = spawn_information.pipe_gap
	var gap_y = spawn_information.pipe_gap_y

	create_pipe_pair(pipe_gap, gap_y, position)

	
func create_pipe_pair(pipe_gap:int, gap_y:int, position:int):
	var pipe_pair = pipe_pair_scene.instantiate() as PipePair
	pipe_pair.global_position.x = position
	pipe_pair.gap_height = pipe_gap
	pipe_pair.gap_y = gap_y
	pipes_container.add_child(pipe_pair)
	return pipe_pair
	
func create_enemy(position: int, spawn_config: Dictionary, parent: Node2D = null) -> EnemyScene:
	var enemy = enemy_scene.instantiate() as EnemyScene
	enemy.setup_health(spawn_config.enemy_health)
	enemy.setup_movement(spawn_config.enemy_can_move)
	enemy.global_position.x = position
	var target_parent = parent if parent else enemy_container
	if parent == null:
		enemy.global_position.y = screen_height / 2
	target_parent.add_child(enemy)
	return enemy
