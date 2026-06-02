@tool

class_name ButtonWithSound extends TextureButton
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@export var text: String:
	get: 
		return text
	set(value):
		text = value
		if Engine.is_editor_hint():
			label.text = value
		
@onready var label: Label = $Label

func _ready() -> void:
	label.text = text

func _pressed() -> void:
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
