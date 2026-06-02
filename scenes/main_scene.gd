extends Node2D

@onready var start_game: ButtonWithSound = $CanvasLayer/VBoxContainer/StartGame

func _ready() -> void:
	start_game.grab_focus()

func _on_exit_game_pressed() -> void:
	GameManager.quit_game()

func _on_start_game_pressed() -> void:
	GameManager.start_game()
