extends CanvasLayer

func _on_exit_to_main_menu_pressed() -> void:
	GameManager.go_to_main_menu()

func _on_continue_pressed() -> void:
	GameManager.unpause()
