class_name EnemyScene extends Area2D

@export var damage:int =1
@export var kill_score:int=1
# Called when the node enters the scene tree for the first time.

func _on_health_component_died() -> void:
	GameManager.add_score(kill_score)
	die()
	
func die():
	print("run die animation")
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	HealthUtils.trigger_take_damege_on_health_component(body,damage)
