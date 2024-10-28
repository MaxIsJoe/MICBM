extends Control


func _ready() -> void:
	Game.gameholder = self
	Game.start_run()
	match_window_size()
	get_viewport().size_changed.connect(match_window_size)


func match_window_size():
	var target_size: Vector2 = Vector2(DisplayServer.window_get_size())
	size = target_size
	%viewport.size = target_size

func set_shaderfication(what: bool):
	%shaderiser.visible = what
