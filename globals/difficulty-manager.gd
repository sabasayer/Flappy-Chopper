extends Node


enum SpawnType {
	PIPE,
	PIPE_WITH_ENEMY,
	ENEMY_ONLY
}

const PIPE_PAIR_GAP_SETTING_BY_DISTANCE = {
	0: { 'gap_height_range': [260, 340], 'gap_padding': 120 },
	1500: { 'gap_height_range': [250, 330], 'gap_padding': 115 },
	2800: { 'gap_height_range': [230, 310], 'gap_padding': 105 },
	4500: { 'gap_height_range': [230, 290], 'gap_padding': 100 },
	6500: { 'gap_height_range': [200, 270], 'gap_padding': 90 },
}

const SPAWN_CONFIG_BY_DISTANCE = {
	0: {
		'spawn_distance': [220, 360],
		'enemy_health': 1,
		'enemy_can_move': false,
		'spawn_type_percentage': {
			100: SpawnType.PIPE
		},
	},
	1500: {
		'spawn_distance': [220, 360],
		'enemy_health': 1,
		'enemy_can_move': false,
		'spawn_type_percentage': {
			85: SpawnType.PIPE,
			15: SpawnType.ENEMY_ONLY
		}
	},
	2800: {
		'spawn_distance': [220, 360],
		'enemy_health': 1,
		'enemy_can_move': false,
		'spawn_type_percentage': {
			65: SpawnType.PIPE,
			20: SpawnType.ENEMY_ONLY,
			15: SpawnType.PIPE_WITH_ENEMY
		}
	},
	4500: {
		'spawn_distance': [160, 280],
		'enemy_health': 2,
		'enemy_can_move': false,
		'spawn_type_percentage': {
			50: SpawnType.PIPE,
			20: SpawnType.ENEMY_ONLY,
			30: SpawnType.PIPE_WITH_ENEMY
		}
	},
	6500: {
		'spawn_distance': [140, 260],
		'enemy_health': 2,
		'enemy_can_move': true,
		'spawn_type_percentage': {
			30: SpawnType.PIPE,
			15: SpawnType.ENEMY_ONLY,
			55: SpawnType.PIPE_WITH_ENEMY
		}
	}
}

var player: Player:
	get():
		return get_tree().get_first_node_in_group("player") as Player

var player_distance: float:
	get():
		return player.global_position.x

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

var curent_spawn_distance: Array:
	get():
		return current_spawn_type_config.spawn_distance

func get_next_spawn_information():
	var pipe_pair_config = DifficultyManager.current_pipe_pair_config
	var spawn_config = DifficultyManager.current_spawn_type_config
	
	if !pipe_pair_config: 
		print("no pipe pair config found for distance:", player_distance)
		return
	
	if !spawn_config: 
		print("no spawn config found for distance:", spawn_config)
		return
		
	var spawn_types = spawn_config.spawn_type_percentage as Dictionary[int,DifficultyManager.SpawnType]
	
	if !spawn_types: 
		print("no spawn type found for spawn config:", spawn_types)
		return
		
	var type = get_spawn_type(spawn_types)
	
	if type == null:
		return

	return {
		'type': type,
		'pipe_pair_config': pipe_pair_config,
		'spawn_config': spawn_config
	}


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
