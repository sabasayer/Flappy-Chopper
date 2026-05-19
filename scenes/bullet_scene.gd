class_name Bullet

extends Area2D

@export var damage:int = 1
var speed:int = 600

func _physics_process(delta: float) -> void:
	position.x += speed * delta


func _on_area_entered(area: Area2D) -> void:
	HealthUtils.trigger_take_damege_on_health_component(area,self,damage)
	
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
