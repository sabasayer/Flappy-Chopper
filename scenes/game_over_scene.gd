extends CanvasLayer


func _input(ev):
	if ev is InputEventKey:
		GameManager.start_game()

func _on_exit_to_main_menu_pressed() -> void:
	GameManager.go_to_main_menu()
