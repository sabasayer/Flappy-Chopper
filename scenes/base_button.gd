@tool

class_name ButtonWithSound extends TextureButton

@export var audio_stream: AudioStream:
	set(value):
		audio_stream = value
		if Engine.is_editor_hint():
			audio.stream = audio_stream
			
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@export var text: String:
	set(value):
		text = value
		if label:
			label.text = value
		
@onready var label: Label = $Label

var tween:Tween

func _ready() -> void:
	label.text = text
	audio.stream = audio_stream

func _pressed() -> void:
	var pitch := randf_range(0.9, 1.1)
	if Engine.is_editor_hint():
		audio.pitch_scale = pitch
		audio.play()
		return
	GameManager.play_ui_click(audio.stream, pitch)
	

func animate():
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self,"scale", Vector2(1.1,1.2),0.35)
	tween.tween_property(self,"rotation", deg_to_rad(10),0.1)
	tween.tween_property(self,"rotation", 0, 0.1).set_delay(0.1)

func reset():
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self,"scale", Vector2.ONE,0.35)
	tween.tween_property(self,"rotation", 0, 0.1).set_delay(0.1)

func _on_mouse_entered() -> void:
	animate()


func _on_focus_entered() -> void:
	animate()


func _on_focus_exited() -> void:
	reset()

func _on_mouse_exited() -> void:
	reset()
