class_name Spawner extends Node2D

enum SpawnType {
	PIPE,
	PIPE_WITH_ENEMY,
	ENEMY_ONLY
}

const PIPE_PAIR_GAP_SETTING_BY_DISTANCE = {
	0: { 'gap_height_range': [350,400], 'gap_padding':200 },
	1000: { 'gap_height_range': [300,400], 'gap_padding':200 },
	2000: { 'gap_height_range': [300,400], 'gap_padding':150 },
}

const SPAWN_CONFIG_BY_DISTANCE = {
	0: {
		'spawn_type_percentage': {
			100: SpawnType.PIPE
		},
	},
	1000: {
		'spawn_type_percentage': {
			70: SpawnType.PIPE,
			30: SpawnType.ENEMY_ONLY
		}
	},
	2000: {
		'spawn_type_percentage': {
			50: SpawnType.PIPE,
			30: SpawnType.ENEMY_ONLY,
			20: SpawnType.PIPE_WITH_ENEMY
		}
	},
	4000: {
		'spawn_type_percentage': {
			45: SpawnType.PIPE_WITH_ENEMY,
			35: SpawnType.PIPE,
			20: SpawnType.ENEMY_ONLY,
		}
	},
	6000: {
		'spawn_type_percentage': {
			55: SpawnType.PIPE_WITH_ENEMY,
			35: SpawnType.PIPE,
			10: SpawnType.ENEMY_ONLY,
		}
	}
}

@export var pipe_pair_scene: PackedScene = preload("res://scenes/pipe-pair.tscn")
@export var enemy_scene: PackedScene = preload("res://scenes/enemy-scene.tscn")
@export var pipes_container: Node2D
@export var enemy_container: Node2D
@export var min_spawn_distance: int = 150
@export var max_spawn_distance: int = 300

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

func check_and_spawn():
	var visible_right = camera.global_position.x + screen_width / 2 
	while visible_right + spawn_margin > next_spawn_x:
		print("spawning")
		next_spawn_x += randi_range(min_spawn_distance,max_spawn_distance)
		spawn(next_spawn_x)

func get_current_config_by_distance(config):
	var current_player_distance = player_distance
	var found_config
	for distance in config:
		if current_player_distance >= distance:
			found_config = config[distance]
	
	return found_config
		
var current_pipe_pair_config:
	get():
		return get_current_config_by_distance(PIPE_PAIR_GAP_SETTING_BY_DISTANCE)

var current_spawn_type_config:
	get():
		return get_current_config_by_distance(SPAWN_CONFIG_BY_DISTANCE)

		
func spawn(position: int):
	print("spawn to:" ,position)
	
	var pipe_pair_config = current_pipe_pair_config
	var spawn_config = current_spawn_type_config
	
	if !pipe_pair_config: 
		print("no pipe pair config found for distance:", player_distance)
		return
	
	if !spawn_config: 
		print("no spawn config found for distance:", spawn_config)
		return
		
	var spawn_types = spawn_config.spawn_type_percentage as Dictionary[int,SpawnType]
	
	if !spawn_types: 
		print("no spawn type found for spawn config:", spawn_types)
		return
		
	var type = get_spawn_type(spawn_types)
	
	if type == null:
		return

	match type:
		SpawnType.ENEMY_ONLY:
			print("spawn enemy only")
			create_enemy(position)
		SpawnType.PIPE:
			print("spawn pipe only")
			create_pipe_pair(pipe_pair_config,position)
		SpawnType.PIPE_WITH_ENEMY:
			print("spawn pipe with enemy only")
			var pipe_pair = create_pipe_pair(pipe_pair_config,position)
			var enemy = create_enemy(position)
			pipe_pair.enemy_marker.add_child(enemy)
		_:
			print("type not matched", type)

func get_spawn_type(spawn_types):
	var type_percentage = randi_range(0,100)
	
	var type
	for percentage in spawn_types:
		if percentage >= type_percentage:
			type = spawn_types[percentage]
			return type
		else:
			type_percentage -= percentage
			 
	if type == null:
		print("no type found for the percentage: ", type_percentage)
	
	return type
	
func create_pipe_pair(pipe_pair_config, position:int):
	var pipe_pair = pipe_pair_scene.instantiate() as PipePair
	pipe_pair.global_position.x = position
	pipe_pair.gap_height_min = pipe_pair_config.gap_height_range[0]
	pipe_pair.gap_height_max = pipe_pair_config.gap_height_range[1]
	pipe_pair.gap_padding = pipe_pair_config.gap_padding
	pipes_container.add_child(pipe_pair)
	return pipe_pair
	
func create_enemy(position:int):
	var enemy = enemy_scene.instantiate() as EnemyScene
	enemy.global_position.x = position
	enemy.global_position.y = screen_height/2
	enemy_container.add_child(enemy)
	return enemy
