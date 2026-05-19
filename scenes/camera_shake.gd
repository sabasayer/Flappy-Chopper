class_name CameraShakable extends Camera2D

@export var max_shake_offset: float = 12.0
@export var decay_speed: float = 4.0

var _base_offset: Vector2
var _trauma: float = 0.0


func _ready() -> void:
	_base_offset = offset


func _process(delta: float) -> void:
	if _trauma <= 0.0:
		offset = _base_offset
		return

	_trauma = maxf(_trauma - decay_speed * delta, 0.0)
	var shake_amount := _trauma * _trauma * max_shake_offset
	offset = _base_offset + Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
	)


func shake(trauma_amount: float = 0.6) -> void:
	_trauma = minf(_trauma + trauma_amount, 1.0)
