class_name PipePair extends Node2D

@export var gap_height_min: int = 200
@export var gap_height_max: int = 400
@export var gap_height: int
@export var gap_y: int
@export var gap_padding: int = 100

@onready var top_pipe: Pipe = $TopPipe
@onready var bottom_pipe: Pipe = $BottomPipe

var scored = false

var player: Player:
	get():
		return get_tree().get_first_node_in_group("player") as Player 

var screen_height:
	get():
		return get_viewport_rect().size.y

var gap_y_max:
	get():
		return screen_height - gap_padding

func _ready() -> void:
	if !gap_y:
		gap_y = randi_range(gap_padding,gap_y_max)
		
	if !gap_height:
		gap_height = randi_range(gap_height_min, gap_height_max)
		
	setup(gap_height,gap_y)

func setup(gap_height: int, gap_y: int):
	if gap_y < gap_padding:
		gap_y = gap_padding
	if gap_y + gap_height > gap_y_max:
		gap_y = gap_y_max - gap_height
	
	var top_pipe_target_size = gap_y
	var top_pipe_size = top_pipe.get_size()
	var target_scale = top_pipe_target_size / top_pipe_size.y
	
	top_pipe.scale.y = target_scale
	top_pipe.position.y = top_pipe_target_size / 2
	
	var bottom_pipe_size = bottom_pipe.get_size()
	var bottom_pipe_target_top = gap_y + gap_height
	var bottom_target_size = screen_height - bottom_pipe_target_top
		
	bottom_pipe.scale.y = bottom_target_size / bottom_pipe_size.y
	bottom_pipe.position.y = screen_height - bottom_target_size / 2
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if scored:
		return
	if body is Player:
		GameManager.add_score(1)
		scored = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
