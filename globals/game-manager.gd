extends Node

var player_score := 0
var player_high_score := 0

func add_score(score: int) -> void:
	player_score += score
	if player_score > player_high_score:
		player_high_score = player_score

func reset_score() -> void:
	player_score = 0

func save_high_score() -> void:
	#todo: save high score to file
	pass