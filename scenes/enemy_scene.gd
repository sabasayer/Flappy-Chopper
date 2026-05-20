class_name EnemyScene extends Node2D

@export var damage: int = 1
@export var kill_score: int = 1
@onready var hurt_spark_particles: HurtSparkParticle = $VisualContainer/HurtSparkParticles
@onready var sprite_2d: Sprite2D = $VisualContainer/Sprite2D

func _on_health_component_died() -> void:
	GameManager.add_score(kill_score)
	die()

func die() -> void:
	print("run die animation")
	queue_free()

func _on_visual_container_body_entered(body: Node2D) -> void:
	HealthUtils.trigger_take_damege_on_health_component(body, self, damage)

func flash_animation():
	sprite_2d.modulate = Color.RED
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d,"modulate",Color.WHITE,0.5).set_trans(Tween.TRANS_SINE)
	
func squash_animation():
	sprite_2d.scale = Vector2(0.9, 1)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d,"scale",Vector2.ONE,0.5).set_trans(Tween.TRANS_SINE)

func _on_health_component_damaged(hit_info: HitInfo) -> void:
	hurt_spark_particles.run_hurt_particles(hit_info)
	flash_animation()
	squash_animation()
