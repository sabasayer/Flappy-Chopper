class_name Spawner extends Node2D

enum SpawnType {
	PIPE,
	PIPE_WITH_ENEMY,
	ENEMY_ONLY
}

const ENEMY_SPAWN_PERCENTAGE_BY_DISTANCE = {
	1000: 10,
	2000: 25,
	4000: 50,
	6000: 70,
	9000: 95
}

const PIPE_PAIR_GAP_SETTING_BY_DISTANCE = {
	0: { 'gap_height_range': [350,400], 'gap_padding':200 },
	1000: { 'gap_height_range': [300,400], 'gap_padding':200 },
	2000: { 'gap_height_range': [300,400], 'gap_padding':150 },
}

@export var pipe_pair_scene: PackedScene = preload("res://scenes/pipe-pair.tscn")
@export var enemy_scene: PackedScene = preload("res://scenes/enemy-scene.tscn")
@export var pipes_container: Node2D
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

func check_and_spawn():
	var visible_right = camera.global_position.x + screen_width / 2 
	while visible_right + spawn_margin > next_spawn_x:
		print("spawning")
		next_spawn_x += randi_range(min_spawn_distance,max_spawn_distance)
		spawn(next_spawn_x)
		
var current_pipe_pair_config:
	get():
		var current_player_distance = player_distance
		var config
		for distance in PIPE_PAIR_GAP_SETTING_BY_DISTANCE:
			if current_player_distance >= distance:
				config = PIPE_PAIR_GAP_SETTING_BY_DISTANCE[distance]
		
		return config
		
		
func spawn(position: int):
	print("spawn to:" ,position)
	
	var config = current_pipe_pair_config
	
	if !config: 
		print("no config found for distance:", player_distance)
		return
		
	var pipe_pair = pipe_pair_scene.instantiate() as PipePair
	pipe_pair.global_position.x = position
	pipe_pair.gap_height_min = config.gap_height_range[0]
	pipe_pair.gap_height_max = config.gap_height_range[1]
	pipe_pair.gap_padding = config.gap_padding
	pipes_container.add_child(pipe_pair)
	
	if should_spawn_enemy():
		print("spawn enemy")
		var enemy = enemy_scene.instantiate() as EnemyScene
		pipe_pair.enemy_marker.add_child(enemy)
	
func should_spawn_enemy():
	var current_player_distance = player_distance
	var percentage = 0
	for distance in ENEMY_SPAWN_PERCENTAGE_BY_DISTANCE:
		if current_player_distance > distance:
			percentage = ENEMY_SPAWN_PERCENTAGE_BY_DISTANCE[distance]
			
	if percentage == 0:
		return false
	
	var range = randi_range(0,100)
	return range < percentage
	
	
