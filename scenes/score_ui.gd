extends CanvasLayer

@onready var score_label: Label = $ScoreLabel

func _ready():
	GameManager.score_changed.connect(_on_score_changed)
	_on_score_changed(GameManager.player_score)
	
func _on_score_changed(new_score:int):
	score_label.text = "Score: %d" % new_score
