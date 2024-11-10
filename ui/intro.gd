extends Control


@export var game_scene: PackedScene = null

func _ready() -> void:
	$textholder/label.text = Game.next_player.intro_text
	%proceed.grab_focus()

func _on_proceed_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
