class_name EnemyScene extends Node2D

@export var damage: int = 1
@export var kill_score: int = 1

func _on_health_component_died() -> void:
	GameManager.add_score(kill_score)
	die()

func die() -> void:
	print("run die animation")
	queue_free()

func _on_visual_container_body_entered(body: Node2D) -> void:
	HealthUtils.trigger_take_damege_on_health_component(body, self, damage)
