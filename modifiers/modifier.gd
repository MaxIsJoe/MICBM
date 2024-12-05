class_name Modifier
extends Node

var type: ModifierType = null
var disabled: bool = false: set = set_disabled
var father: Entity = null

signal disabled_changed

func _init() -> void:
	add_to_group("modifiers")

func _exit_tree() -> void:
	if is_instance_valid(father):
		get_unequipped(father)

func get_equipped(by: Entity):
	father = by
	if (father != null && father.is_in_group("player")): GlobalSound.play_sfx_stream(type.activation_audio)

func activate(_context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = ModifierResult.new()
	return output

func get_unequipped(_by: Entity):
	pass

func set_disabled(what: bool):
	disabled = what
	disabled_changed.emit()
