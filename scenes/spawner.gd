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
	var spawn_distance = DifficultyManager.curent_spawn_distance as Array
	while visible_right + spawn_margin > next_spawn_x:
		print("spawning")
		next_spawn_x += randi_range(spawn_distance[0], spawn_distance[1])
		spawn(next_spawn_x)

		
func spawn(position: int):
	print("spawn to:" ,position)
	
	var spawn_information = DifficultyManager.get_next_spawn_information()
	if !spawn_information:
		print("no spawn information found for distance:", player_distance)
		return

	var type = spawn_information.type
	var pipe_pair_config = spawn_information.pipe_pair_config
	var spawn_config = spawn_information.spawn_config

	match type:
		DifficultyManager.SpawnType.ENEMY_ONLY:
			print("spawn enemy only")
			create_enemy(position, spawn_config)
		DifficultyManager.SpawnType.PIPE:
			print("spawn pipe only")
			create_pipe_pair(pipe_pair_config,position)
		DifficultyManager.SpawnType.PIPE_WITH_ENEMY:
			print("spawn pipe with enemy only")
			var pipe_pair = create_pipe_pair(pipe_pair_config,position)
			create_enemy(position,spawn_config, pipe_pair.enemy_marker)
		_:
			print("type not matched", type)

	
func create_pipe_pair(pipe_pair_config, position:int):
	var pipe_pair = pipe_pair_scene.instantiate() as PipePair
	pipe_pair.global_position.x = position
	pipe_pair.gap_height_min = pipe_pair_config.gap_height_range[0]
	pipe_pair.gap_height_max = pipe_pair_config.gap_height_range[1]
	pipe_pair.gap_padding = pipe_pair_config.gap_padding
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
