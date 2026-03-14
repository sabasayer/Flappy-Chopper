class_name Spawner extends Node2D

enum SpawnType {
	PIPE,
	PIPE_WITH_ENEAMY,
	ENEMY_ONLY
}

@export var pipe_scene: PackedScene = preload("res://scenes/pipe.tscn")
@export var min_spawn_distance: int = 150
@export var max_spawn_distance: int = 300

var player: Player:
	get():
		return get_tree().get_first_node_in_group("player") as Player
	
