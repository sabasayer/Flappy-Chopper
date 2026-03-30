class_name LevelScene

extends Node2D

@export var player: Player
@export var pipe_scene: PackedScene
@export var end_of_level_position: float = 10000

@onready var playerPosition: Marker2D = $PlayerPosition
@onready var spawner: Spawner = $Spawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_player_position()

func restart_level() -> void:
	get_tree().reload_current_scene()

func reset_player_position() -> void:
	player.global_position = playerPosition.global_position

func _on_ground_area_entered(_body: Node2D) -> void:
	print("ground entered")
	restart_level()

func _on_player_player_died() -> void:
	restart_level()

func _process(delta: float) -> void:
	spawner.check_and_spawn()
