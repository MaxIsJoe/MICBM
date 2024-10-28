extends Node


signal money_changed
signal progress_changed
signal enemy_got_attacked
signal player_got_attacked
signal friendly_fire_happened


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
