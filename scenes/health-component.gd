class_name HealthComponent extends Node

signal died(hit_info:HitInfo)
signal damaged(hit_info:HitInfo)

@export var max_health:int = 1

var health:int
var disabled:bool = false

func _ready() -> void:
	health = max_health
	
func take_damage(hit_info:HitInfo):
	if disabled:
		return
		
	print("take damage: ", hit_info)
	health -= hit_info.damage
	if health <= 0:
		died.emit(hit_info)
	else:
		damaged.emit(hit_info)
		

func disable():
	disabled = true
	
func enable():
	disabled = false
