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
	for pack in Music.song_packs:
		var pack_button : CheckButton = CheckButton.new()
		pack_button.text = pack.PackName
		pack_list.add_child(pack_button)

func generate_pack_creator_fields():
	# Clear any existing children (in case the function is called multiple times)
	var newPack = SongPackData.new()
	for child in create_songpack_ui.get_children():
		child.queue_free()

	# Create a label and LineEdit for the PackName
	var pack_name_label : Label = Label.new()
	pack_name_label.text = "Pack Name:"
	create_songpack_ui.add_child(pack_name_label)

	var pack_name_input : LineEdit = LineEdit.new()
	pack_name_input.text = "New Pack"
	pack_name_input.name = "PackNameInput"
	create_songpack_ui.add_child(pack_name_input)
	
	song_inputs["PackNameInput"] = pack_name_input

	# Create input fields for each song in the Songs dictionary
	for song_name in newPack.Songs.keys():
		# Create an HBoxContainer to place the LineEdit and File Picker button horizontally
		var song_hbox = HBoxContainer.new()

		var song_label = Label.new()
		song_label.text = song_name + ":"
		create_songpack_ui.add_child(song_label)

		# LineEdit for song path
		var song_input = LineEdit.new()
		song_input.custom_minimum_size = Vector2(350, 10)
		song_input.text = ""
		song_input.placeholder_text = "Choose a file..."
		song_input.name = song_name + "Input"
		song_hbox.add_child(song_input)
		song_inputs[song_name] = song_input

		# Button to trigger file picker
		var file_picker_button = Button.new()
		file_picker_button.text = "Browse"
		file_picker_button.name = song_name + "_FilePicker"
		file_picker_button.connect("pressed", Callable(self, "_on_browse_button_pressed").bind(song_name, song_input))
		song_hbox.add_child(file_picker_button)

		# Add the HBoxContainer to the UI
		create_songpack_ui.add_child(song_hbox)
		
	create_songpack.hide()
	var save_button = Button.new()
	save_button.text = "Save"
	save_button.name = "SaveButton"
	save_button.connect("pressed", Callable(self, "_on_save_button_pressed"))  # Save functionality to be added later
	create_songpack_ui.add_child(save_button)

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


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		for button in pack_list.get_children():
			button.button_pressed = false
