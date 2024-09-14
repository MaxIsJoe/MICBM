extends Button

var character: PlayerInfo
signal on_selected(player_info)


func setup(newChar: PlayerInfo, select: Callable):
	character = newChar
	icon = newChar.character_icon
	tooltip_text = newChar.character_name
	on_selected.connect(select)

func _on_on_selected(player_info: Variant) -> void:
	on_selected.emit(player_info)

func _on_button_down() -> void:
	on_selected.emit(character)
