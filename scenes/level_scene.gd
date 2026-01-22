class_name LevelScene

extends Node2D

@export var player: Player

@onready var playerPosition: Marker2D = $PlayerPosition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_player_position()

func restart_level() -> void:
	reset_player_position()

func reset_player_position() -> void:
	player.global_position = playerPosition.global_position

func _on_ground_area_entered(_body: Node2D) -> void:
	print("ground entered")
	restart_level()
