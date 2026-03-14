class_name Bullet

extends Area2D

var speed:int = 600

func _physics_process(delta: float) -> void:
	position.x += speed * delta


func _on_area_entered(area: Area2D) -> void:
	print("area entered",area)
	queue_free()

func _on_body_exited(body: Node2D) -> void:
	if(body is Player):
		return
	print("body hit",body)
	
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
