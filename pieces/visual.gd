@tool
extends Node2D


@export var texture: Texture2D = null: set = set_texture


func play_animation(what: String):
	%animator.play(what)

func add_sprite(what: Texture2D) -> Sprite2D:
	var new_sprite: Sprite2D = Sprite2D.new()
	new_sprite.texture = what
	%warpable.add_child(new_sprite)
	return new_sprite


func set_texture(what: Texture2D):
	texture = what
	%main_sprite.texture = what
