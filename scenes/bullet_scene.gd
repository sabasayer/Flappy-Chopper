class_name Bullet

extends Area2D

@export var damage:int = 1
var speed:int = 600

func _physics_process(delta: float) -> void:
	position.x += speed * delta
	if _is_offscreen():
		queue_free()


func _is_offscreen() -> bool:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return false
	var half_width := get_viewport().get_visible_rect().size.x / 2.0
	var margin := 64.0
	var right_edge := camera.get_screen_center_position().x + half_width + margin
	return global_position.x > right_edge


func _on_area_entered(area: Area2D) -> void:
	HealthUtils.trigger_take_damege_on_health_component(area,self,damage)
	queue_free()
