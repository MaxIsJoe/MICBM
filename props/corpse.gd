extends Knockable


func _ready() -> void:
	%visual.play_animation("shake")


func set_texture(what: Texture2D):
	%visual.texture = what
