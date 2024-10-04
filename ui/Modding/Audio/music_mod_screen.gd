extends Control

@onready var pack_list: VBoxContainer = $panel/scroll_container/v_box_container/pack_list
@onready var create_songpack_ui: VBoxContainer = $panel/scroll_container/v_box_container/create_songpack_ui
@onready var create_songpack: Button = $panel/scroll_container/v_box_container/create_songpack
@onready var file_dialog: FileDialog = $file_dialog
var song_inputs: Dictionary = {} 
var selected_field : LineEdit = null
var selected_pack: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_pack_options()

func generate_pack_options():
	for item in pack_list.get_children():
		item.queue_free()
	for i in range(len(Music.song_packs)):
		var pack = Music.song_packs[i]
		var pack_button : CheckBox = CheckBox.new()
		pack_button.text = pack.PackName
		pack_button.name = str(i)  # Store the index as the name for reference
		if pack_button.text == OptionsManager.options["last_song_pack"]:
			pack_button.button_pressed = true
		pack_button.connect("toggled", Callable(self, "_on_pack_toggled").bind(pack.PackName, pack_button))  # Bind the index and button itself
		pack_list.add_child(pack_button)
		

func generate_pack_creator_fields():
	var newPack = SongPackData.new()
	for child in create_songpack_ui.get_children():
		child.queue_free()

	var pack_name_label : Label = Label.new()
	pack_name_label.text = "Pack Name:"
	create_songpack_ui.add_child(pack_name_label)

	var pack_name_input : LineEdit = LineEdit.new()
	pack_name_input.text = "New Pack"
	pack_name_input.name = "PackNameInput"
	create_songpack_ui.add_child(pack_name_input)
	
	song_inputs["PackNameInput"] = pack_name_input

	for song_name in newPack.Songs.keys():
		var song_hbox = HBoxContainer.new()

		var song_label = Label.new()
		song_label.text = song_name + ":"
		create_songpack_ui.add_child(song_label)

		var song_input = LineEdit.new()
		song_input.custom_minimum_size = Vector2(350, 10)
		song_input.text = ""
		song_input.placeholder_text = "Choose a file..."
		song_input.name = song_name + "Input"
		song_hbox.add_child(song_input)
		song_inputs[song_name] = song_input

		var file_picker_button = Button.new()
		file_picker_button.text = "Browse"
		file_picker_button.name = song_name + "_FilePicker"
		file_picker_button.connect("pressed", Callable(self, "_on_browse_button_pressed").bind(song_name, song_input))
		song_hbox.add_child(file_picker_button)

		create_songpack_ui.add_child(song_hbox)
		
	create_songpack.hide()
	var save_button = Button.new()
	save_button.text = "Save"
	save_button.name = "SaveButton"
	save_button.connect("pressed", Callable(self, "_on_save_button_pressed"))
	create_songpack_ui.add_child(save_button)
	

func disable_other_toggles(active_button: CheckBox) -> void:
	for child in pack_list.get_children():
		if child != active_button and child is CheckBox:
			child.button_pressed = false

func _on_create_songpack_button_down() -> void:
	generate_pack_creator_fields()
	
# Callback for when a "Browse" button is pressed
func _on_browse_button_pressed(song_name: String, selected: LineEdit) -> void:
	selected_field = selected
	file_dialog.popup()


func _on_file_dialog_file_selected(path: String) -> void:
	selected_field.text = path
	selected_field = null
	
func _on_save_button_pressed() -> void:
	var new_song_pack = SongPackData.new()
	if song_inputs.has("PackNameInput"):
		new_song_pack.PackName = song_inputs["PackNameInput"].text
		print("Pack Name:", new_song_pack.PackName)
	for song_name in new_song_pack.Songs.keys():
		if song_inputs.has(song_name):
			new_song_pack.Songs[song_name] = song_inputs[song_name].text
			print("Song: ", song_name, "Path: ", new_song_pack.Songs[song_name])
	print("New Song Pack Data Created:", new_song_pack)
	Music.song_packs.append(new_song_pack)
	Music.save_song_packs()
	generate_pack_options()
	for child in create_songpack_ui.get_children():
		child.queue_free()
	create_songpack.show()

func _on_pack_toggled(pressed: bool, pack_name: String, button: CheckBox) -> void:
	if pressed:
		disable_other_toggles(button)
		Music.set_current_pack(pack_name)
