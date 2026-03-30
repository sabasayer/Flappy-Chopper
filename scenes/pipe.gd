class_name Pipe
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.on_collision_with_pipe(self)

func get_size():
	return sprite_2d.region_rect.size
