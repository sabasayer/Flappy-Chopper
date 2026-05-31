extends CanvasLayer

@onready var score: Label = $Container/Score
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	GameManager.score_changed.connect(_on_score_changed)
	_on_score_changed(GameManager.player_score)
	
func _on_score_changed(new_score:int):
	score.text = String.num(new_score,0)
	if new_score > 0:
		animation_player.play("score_change")
