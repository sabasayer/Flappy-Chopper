extends Node2D

@onready var start_game: ButtonWithSound = $CanvasLayer/VBoxContainer/StartGame
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	start_game.grab_focus()
	audio_stream_player.play()

func _on_exit_game_pressed() -> void:
	GameManager.quit_game()

func _on_start_game_pressed() -> void:
	GameManager.start_game()
