class_name HealthUtils extends Node

static func trigger_take_damege_on_health_component(node: Node2D, damage:int) -> void:
	print("node entered ",node)
	
	var health := node.get_node_or_null("HealthComponent")
	
	if health is HealthComponent:
		print("health component detected")
		health.take_damage(damage)
