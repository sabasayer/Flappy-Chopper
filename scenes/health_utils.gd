class_name HealthUtils extends Node

static func trigger_take_damege_on_health_component(target: Node2D, source:Node2D, damage:int) -> void:
	print("target entered ",target)
	
	var health := target.get_node_or_null("HealthComponent")
	
	if health is HealthComponent:
		print("health component detected")
		var direction = (target.global_position - source.global_position).normalized()
		var hit_info := HitInfo.new(damage,direction,source.global_position)
		health.take_damage(hit_info)
