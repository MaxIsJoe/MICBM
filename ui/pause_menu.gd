extends Control


@export var main_menu_scene: PackedScene = null


func _init() -> void:
	add_to_group("pausers")


func _on_continue_pressed() -> void:
	queue_free()
	remove_from_group("pausers")
	Game.update_pause_status()

func _on_egress_pressed() -> void:
	remove_from_group("pausers")
	Game.update_pause_status()
	get_tree().change_scene_to_packed(main_menu_scene)
