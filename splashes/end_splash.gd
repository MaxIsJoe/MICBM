class_name FailureScreen
extends Control


func _ready() -> void:
	GlobalSound.stop_music()

func _on_egress_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/title/main_menu.tscn")
