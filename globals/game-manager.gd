extends Node

const FILE_PATH := "user://high_score"
const UI_CLICK := preload("res://assets/kenney_ui-pack/Sounds/click-a.ogg")

enum GAME_STATE {
	LOADING,
	MAIN_MENU,
	LEVEL_STARTING,
	PLAYING,
	PAUSE_MENU,
	GAME_OVER_MENU
}

signal score_changed(new_score:int, old_score)

@onready var level_scene:PackedScene = preload("res://scenes/level-scene.tscn")
@onready var game_over_scene:PackedScene = preload("res://scenes/game_over_scene.tscn")
@onready var pause_menu_scene: PackedScene = preload("res://scenes/pause_menu.tscn")
@onready var main_menu: PackedScene = preload("res://scenes/main_scene.tscn")

var player_score := 0
var player_high_score := 0
var game_state := GAME_STATE.LOADING
var pause_menu_instance: CanvasLayer

func _ready() -> void:
	call_deferred("_warmup_audio")
	read_high_score()

func _warmup_audio() -> void:
	play_ui_click(UI_CLICK, 1.0, -80)

func play_ui_click(stream: AudioStream, pitch_scale: float = 1.0, volume_db: float = 0.0) -> void:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.pitch_scale = pitch_scale
	player.volume_db = volume_db
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if game_state == GAME_STATE.PLAYING:
			pause_menu()
		elif game_state == GAME_STATE.PAUSE_MENU:
			unpause()

func add_score(score: int) -> void:
	var old_score = player_score
	player_score += score
	if player_score > player_high_score:
		player_high_score = player_score
		save_high_score()
	score_changed.emit(player_score, old_score)

func reset_score() -> void:
	player_score = 0
	
func read_high_score():
	var file := FileAccess.open(FILE_PATH, FileAccess.READ)
	if !file:
		return
		
	var value = file.get_64()
	if value:
		player_high_score = value

func save_high_score() -> void:
	if !player_high_score:
		return
		
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	if !file:
		return
		
	file.store_64(player_high_score)

func start_game():
	reset_score()
	var res = get_tree().change_scene_to_packed(level_scene)
	if res == Error.OK:
		game_state = GAME_STATE.LEVEL_STARTING
		
func playing():
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
