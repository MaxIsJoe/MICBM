extends Control

@export var intro_scene: PackedScene = null
@export var characters_resources: ResourceGroup
@export var character_button: PackedScene
@export var character_name: RichTextLabel
@export var character_desc: RichTextLabel
@export var character_icon: TextureRect
@export var character_buttons_grid: GridContainer

var selected_character: PlayerInfo = null
var characters: Array[PlayerInfo]


func _ready() -> void:
	var load_characters = characters_resources.load_all()
	for char in load_characters:
		if char is not PlayerInfo: continue
		characters.append(char)
	for loaded_char in characters:
		var newButton = character_button.instantiate()
		newButton.setup(loaded_char, on_selected_new_character)
		character_buttons_grid.add_child(newButton)
	on_selected_new_character(characters[0])
	
func on_selected_new_character(playerinfo: PlayerInfo):
	selected_character = playerinfo
	Game.next_player = playerinfo
	character_name.text = selected_character.character_name
	character_desc.text = selected_character.character_desc
	character_icon.texture = selected_character.character_icon

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(intro_scene)
