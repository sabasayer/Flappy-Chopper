class_name LevelScene

extends Node2D

@export var player: Player
@export var pipe_scene: PackedScene
@export var end_of_level_position: float = 10000

@onready var playerPosition: Marker2D = $PlayerPosition
@onready var spawner: Spawner = $Spawner
@onready var get_ready: Sprite2D = $GetReady
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_player_position()
	get_ready.visible = true
	await get_tree().create_timer(1).timeout
	get_ready.visible = false
	GameManager.playing()
	var pitch := randf_range(0.9, 1.1)
	audio_stream_player.pitch_scale = pitch
	audio_stream_player.play()
	

func restart_level() -> void:
	get_tree().reload_current_scene()

func reset_player_position() -> void:
	player.global_position = playerPosition.global_position

func _on_ground_area_entered(_body: Node2D) -> void:
	print("ground entered")
	GameManager.game_over()

func _on_player_player_died() -> void:
	GameManager.game_over()
