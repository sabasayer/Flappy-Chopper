class_name EnemyScene extends Node2D

const HEALTH_COLORS = {
	1: Color.WHITE,
	2: Color(1.0, 0.55, 0.45),
	3: Color(1.0, 0.3, 0.35),
}

@export var damage: int = 1
@export var kill_score: int = 5
@export var can_move: bool = false
@onready var hurt_spark_particles: HurtSparkParticle = $VisualContainer/HurtSparkParticles
@onready var sprite_2d: Sprite2D = $VisualContainer/Sprite2D
@onready var visual_container: Area2D = $VisualContainer
@onready var smoke_explosion_particles: GPUParticles2D = $VisualContainer/SmokeExplosionParticles
@onready var spark_explosion_particles: GPUParticles2D = $VisualContainer/SparkExplosionParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var base_color: Color = Color.WHITE

func setup_health(max_health: int) -> void:
	var component := $VisualContainer/HealthComponent as HealthComponent
	component.max_health = max_health
	base_color = HEALTH_COLORS.get(max_health, HEALTH_COLORS[3])
	$VisualContainer/Sprite2D.modulate = base_color

func setup_movement(enabled: bool) -> void:
	can_move = enabled

func _ready() -> void:
	if can_move:
		animation_player.play("idle")

func _on_health_component_died(hit_info:HitInfo) -> void:
	GameManager.add_score(kill_score)
	die(hit_info)

func die(hit_info: HitInfo) -> void:
	print("run die animation")
	visual_container.set_deferred("monitorable",false)
	visual_container.set_deferred("monitoring",false)
	animation_player.pause()
	hurt_spark_particles.run_hurt_particles(hit_info)
	smoke_explosion_particles.emitting = true
	spark_explosion_particles.emitting = true
	await scale_fade_animation().finished
	queue_free()

func _on_visual_container_body_entered(body: Node2D) -> void:
	HealthUtils.trigger_take_damege_on_health_component(body, self, damage)

func scale_fade_animation() -> Tween:
	var tween := get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite_2d,"scale",Vector2(1.2,1.2),0.3).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(sprite_2d,"modulate",Color.TRANSPARENT,0.3).set_trans(Tween.TRANS_LINEAR)
	return tween 

func flash_animation() -> Tween:
	sprite_2d.modulate = Color.RED
	var tween := get_tree().create_tween()
	tween.tween_property(sprite_2d, "modulate", base_color, 0.5).set_trans(Tween.TRANS_SINE)
	return tween
	
func squash_animation():
	sprite_2d.scale = Vector2(0.9, 1)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d,"scale",Vector2.ONE,0.5).set_trans(Tween.TRANS_SINE)

func _on_health_component_damaged(hit_info: HitInfo) -> void:
	hurt_spark_particles.run_hurt_particles(hit_info)
	flash_animation()
	squash_animation()
