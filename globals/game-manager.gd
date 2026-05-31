extends Node

enum GAME_STATE {
	LOADING,
	MAIN_MENU,
	PLAYING,
	PAUSE_MENU,
	GAME_OVER_MENU
}

signal score_changed(new_score:int)

@onready var level_scene:PackedScene = preload("res://scenes/level-scene.tscn")
@onready var game_over_scene:PackedScene = preload("res://scenes/game_over_scene.tscn")
@onready var pause_menu_scene: PackedScene = preload("res://scenes/pause_menu.tscn")
@onready var main_menu: PackedScene = preload("res://scenes/main_scene.tscn")

var player_score := 0
var player_high_score := 0
var game_state := GAME_STATE.LOADING
var pause_menu_instance: CanvasLayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if game_state == GAME_STATE.PLAYING:
			pause_menu()
		elif game_state == GAME_STATE.PAUSE_MENU:
			unpause()

func add_score(score: int) -> void:
	player_score += score
	if player_score > player_high_score:
		player_high_score = player_score
	score_changed.emit(player_score)

func reset_score() -> void:
	player_score = 0

func save_high_score() -> void:
	#todo: save high score to file
	pass

func start_game():
	reset_score()
	var res = get_tree().change_scene_to_packed(level_scene)
	if res == Error.OK:
		game_state = GAME_STATE.PLAYING

func quit_game():
	get_tree().quit()
	
func game_over():
	var res = get_tree().change_scene_to_packed(game_over_scene)
	if res == Error.OK:
		game_state = GAME_STATE.GAME_OVER_MENU
	
func pause_menu():
	pause_menu_instance = pause_menu_scene.instantiate()
	var current_scene = get_tree().current_scene
	if !current_scene:
		return
		
	current_scene.add_child(pause_menu_instance)
	Engine.time_scale = 0
	pause_menu_instance.layer = 2
	game_state = GAME_STATE.PAUSE_MENU
	
func unpause():
	if !pause_menu_instance:
		return
		
	pause_menu_instance.queue_free()
	Engine.time_scale = 1.0
	game_state = GAME_STATE.PLAYING

func go_to_main_menu():
	var res = get_tree().change_scene_to_packed(main_menu)
	if res == Error.OK:
		game_state = GAME_STATE.MAIN_MENU
