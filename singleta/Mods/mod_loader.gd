extends Node

# Path to the "mods" folder next to the game's executable
const MODS_FOLDER_PATH := "res://mods/"

# Called when the node enters the scene tree for the first time
func _ready():
	load_mods()

# Load all mods (DLCs) from the specified folder
func load_mods():
	var dir := DirAccess.open(MODS_FOLDER_PATH)
	
	if dir == null:
		print("Mod folder not found.")
		return
	
	# Iterate through all files in the mods directory
	while dir.get_next() != "":
		var file_name = dir.current_name()
		
		# Check if the file is a .pck file
		if file_name.ends_with(".zip"):
			var file_path = MODS_FOLDER_PATH + file_name
			if ProjectSettings.load_resource_pack(file_path):
				print("Loaded mod:", file_name)
			else:
				print("Failed to load mod:", file_name)
