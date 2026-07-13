class_name Pipe
extends Node2D

@export var damage :int = 1 
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var sprite_2d_3: Sprite2D = $Sprite2D3

var active_sprite :Sprite2D = sprite_2d

func _ready() -> void:
	var sprites :Array[Sprite2D] = [sprite_2d,sprite_2d_2,sprite_2d_3]
	var index = randi_range(0,2)
	active_sprite = sprites.get(index)
	for sprite in sprites:
		if sprite != active_sprite:
			sprite.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	HealthUtils.trigger_take_damege_on_health_component(body,self,damage)

func get_size():
	return active_sprite.region_rect.size
