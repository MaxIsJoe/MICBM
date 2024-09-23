class_name FailureScreen
extends Control

@onready var animator: AnimationPlayer = $animator

func _on_egress_pressed() -> void:
	Engine.time_scale = 1
	GlobalSound.pitch_shift(1, 1)
	GlobalSound.lower_bus_volume(AudioServer.get_bus_index("Gameplay") , 0, 0.25)
	get_tree().change_scene_to_file("res://ui/title/main_menu.tscn")

func play_fail():
	GlobalSound.pitch_shift(Engine.time_scale, 0.25)
	GlobalSound.lower_bus_volume(AudioServer.get_bus_index("Gameplay") , -32, 1.25)
	animator.play("arrive")
