class_name Pipe
extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.on_collision_with_pipe(self)
