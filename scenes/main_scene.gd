extends Node2D

@onready var start_button: Button = $CanvasLayer/StartButton
@onready var settings_button: Button = $CanvasLayer/SettingsButton
@onready var exit_button: Button = $CanvasLayer/ExitButton

@onready var level_scene: PackedScene = preload("res://scenes/level-scene.tscn")

func _on_exit_button_pressed() -> void:
	GameManager.quit_game()

func _on_start_button_pressed() -> void:
	GameManager.start_game()
