extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var score: Label = %Score

func _ready():
	GameManager.score_changed.connect(_on_score_changed)
	_on_score_changed(GameManager.player_score,0)
	
func _on_score_changed(new_score:int, old_score:int):
	score.text = String.num(new_score,0)
	if new_score > 0:
		if new_score - old_score > 4:
			animation_player.play("score_change_big")
		else:
			animation_player.play("score_change")
