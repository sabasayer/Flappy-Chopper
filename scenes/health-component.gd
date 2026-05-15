class_name HealthComponent extends Node

signal died()
signal damaged(amount:int)

@export var max_health:int = 1

var health:int

func _ready() -> void:
	health = max_health
	
func take_damage(amount:int):
	print("take damage: ", amount)
	health -= amount
	damaged.emit(amount)
	if health <= 0:
		die()
		
func die():
	died.emit()
