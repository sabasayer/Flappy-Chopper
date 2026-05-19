class_name EffectUtils extends Node

static func freeze_frame(duration: float, node: Node):
	Engine.time_scale = 0
	await(node.get_tree().create_timer(duration, true, false, true).timeout)
	Engine.time_scale = 1
