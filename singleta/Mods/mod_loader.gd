extends Node

const MODS_FOLDER_PATH := "Mods/"
@onready var root = ProjectSettings.globalize_path("res://")

var detected_mods: Dictionary = {}

func _ready():
	detect_mods()


func detect_mods():
	var dir := DirAccess.open(root + MODS_FOLDER_PATH)
	
	if dir == null:
		print("Mod folder not found.")
		return
	
	# Iterate through all files in the mods directory
	for file_name in dir.get_files():
		# Check if the file is a .pck file
		if file_name.ends_with(".zip"):
			var file_path = MODS_FOLDER_PATH + file_name
			print("Found: " + file_path)
			var reader := ZIPReader.new()
			var err := reader.open(file_path)
			if err != OK:
				continue
			var modinfo := reader.read_file("Mods/info.ini")
			reader.close()
			var config = ConfigFile.new()
			print(modinfo.get_string_from_ascii())
			config.parse(modinfo.get_string_from_ascii())
			print(config.get_sections())
			detected_mods[file_path] = file_path
		

func load_mods():
	for mod in detected_mods:
		if ProjectSettings.load_resource_pack(mod.value): print("Loaded mod:", mod)
		else: print("Failed to load mod:", mod)
