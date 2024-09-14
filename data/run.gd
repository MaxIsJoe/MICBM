class_name Run
extends RefCounted


var money: float = 0: set = set_money
var max_progress: float = 400
var progress: float = 0: set = set_progress

var win_scene: PackedScene = preload("res://splashes/victory.tscn")


func set_money(what: float):
	money = what
	Events.money_changed.emit()

func set_progress(what: float):
	progress = what
	Events.progress_changed.emit()
	
	if progress >= max_progress:
		Game.end_run()
		Game.get_tree().change_scene_to_packed(win_scene)
