class_name MusicManager
extends Node

var song_packs = []
var current_pack : SongPackData
var current_song : Dictionary = {}

@onready var audio_stream_player: AudioStreamPlayer = $audio_stream_player


func _ready():
	load_song_packs()

# Add a new song pack
func add_song_pack(pack_name: String, songs: Dictionary):
	var new_pack = SongPackData.new()
	new_pack.PackName = "pack_name"
	new_pack.Songs = songs
	song_packs.append(new_pack)
	save_song_packs()

# Remove a song pack by its name
func remove_song_pack(pack_name: String):
	for i in range(song_packs.size()):
		if song_packs[i]["pack_name"] == pack_name:
			song_packs.remove_at(i)
			save_song_packs()
			return


func add_default_pack():
	var default : SongPackData = SongPackData.new()
	default.PackName = "Original OST"
	default.Songs["MainMenu"] = "res://audio/music/Superweapon.ogg"
	default.Songs["Ingame"] = "res://audio/music/ICBM.ogg"
	song_packs.append(default)

# Load song packs from a file
func load_song_packs():
	var config_file := ConfigFile.new()
	var error := config_file.load("user://song_packs.ini")
	if error:
		print("An error happened while loading data: ", error) 
		return
	for loadedPack in config_file.get_sections():
		var pack : SongPackData = SongPackData.new()
		pack.PackName = loadedPack
		pack.Songs = config_file.get_value(loadedPack, "Songs")
		song_packs.append(pack)
	print(song_packs)

# Save the current song packs to a file
func save_song_packs():
	var config_file := ConfigFile.new()
	for pack in song_packs:
		config_file.set_value(pack.PackName, "PackName", pack.PackName)
		config_file.set_value(pack.PackName, "Songs", pack.Songs)
	var error := config_file.save("user://song_packs.ini")
	if error:
		print("An error happened while saving data: ", error)

# Set the currently selected song pack by name
func set_current_pack(pack_name: String):
	for pack in song_packs:
		if pack["pack_name"] == pack_name:
			current_pack = pack
			return

# Get the list of all song packs
func get_song_packs() -> Array:
	return song_packs

# Play a song from the currently selected pack by its name
func play_song(song_name: String):
	if current_pack and current_pack.has("Songs"):
		for song in current_pack["Songs"]:
			if song == song_name:
				current_song = song
				_play_song_path(current_pack["Songs"][song])
				return
	print("Song not found in the current pack.")

# Stop the currently playing song
func stop_song():
	if audio_stream_player.playing:
		audio_stream_player.stop()

# Private function to handle playing a song from its file path
func _play_song_path(path: String):
	var stream = audio_stream_player.load(path)
	if stream:
		audio_stream_player.stream = stream
		audio_stream_player.play()
	else:
		print("Failed to load song at path:", path)

# Utility function to get the current song's BPM
func get_current_bpm() -> int:
	if current_song.has("bpm"):
		return current_song["bpm"]
	return -1
