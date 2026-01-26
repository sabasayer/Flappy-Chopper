class_name LevelScene

extends Node2D

@export var player: Player
@export var pipe_scene: PackedScene
@export var min_pipe_distance: float = 100
@export var max_pipe_distance: float = 200
@export var end_of_level_position: float = 10000

@onready var playerPosition: Marker2D = $PlayerPosition
@onready var pipeSpawnMarkerTop: Marker2D = $PipeSpawnMarkerTop
@onready var pipeSpawnMarkerDown: Marker2D = $PipeSpawnMarkerDown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_player_position()
	spawn_pipe()

func restart_level() -> void:
	reset_player_position()

func reset_player_position() -> void:
	player.global_position = playerPosition.global_position

func _on_ground_area_entered(_body: Node2D) -> void:
	print("ground entered")
	restart_level()

func _on_player_player_died() -> void:
	restart_level()

func spawn_pipe() -> void:
	var pipeSpawnPositionTop = pipeSpawnMarkerTop.global_position
	var pipeSpawnPositionDown = pipeSpawnMarkerDown.global_position

	var pipe_position_x = min(pipeSpawnPositionTop.x, pipeSpawnPositionDown.x)

	while pipe_position_x < end_of_level_position:
		var pipe = pipe_scene.instantiate()
		pipe.globalPosition.x = pipe_position_x
		var is_pipe_top = randf() < 0.5
		if is_pipe_top:
			pipe.globalPosition.y = pipeSpawnPositionTop.y
		else:
			pipe.globalPosition.y = pipeSpawnPositionDown.y

		add_child(pipe)

		pipe_position_x += randf_range(min_pipe_distance, max_pipe_distance)
