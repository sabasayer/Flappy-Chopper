extends HBoxContainer

@onready var high_score: Label = $HighScore

func _ready() -> void:
	var player_high_score = GameManager.player_high_score
	high_score.text = str(player_high_score)
	visible = bool(player_high_score)
