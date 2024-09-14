class_name SFX2D
extends AudioStreamPlayer2D


func _ready() -> void:
	finished.connect(queue_free)
	bus = "SFX"
	play()
