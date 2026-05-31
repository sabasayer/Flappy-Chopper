extends CanvasLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	GameManager.quit_game()

func _input(ev):
	if ev is InputEventKey:
		GameManager.start_game()
