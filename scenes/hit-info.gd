class_name HitInfo
extends RefCounted

var damage: int
var direction: Vector2
var position: Vector2

func _init(p_damage:int, p_direction: Vector2, p_position: Vector2) -> void:
	damage = p_damage
	direction = p_direction
	position = p_position
