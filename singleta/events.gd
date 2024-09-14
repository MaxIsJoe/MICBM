extends Node


signal money_changed
signal progress_changed


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
