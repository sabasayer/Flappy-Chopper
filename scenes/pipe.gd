class_name Pipe
extends Node2D

@export var damage :int = 1 
@onready var sprite_2d: Sprite2D = $Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	HealthUtils.trigger_take_damege_on_health_component(body,self,damage)

func get_size():
	return sprite_2d.region_rect.size
