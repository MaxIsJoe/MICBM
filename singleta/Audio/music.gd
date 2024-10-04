class_name MusicManager
extends Node

var song_packs = []
var current_pack : SongPackData
var current_song_id_to_play : String = "MainMenu"


@onready var audio_stream_player: AudioStreamPlayer = $audio_stream_player

signal on_pack_changed

func _ready():
	on_pack_changed.connect(_on_song_pack_changed)
	load_song_packs()

# Add a new song pack
func add_song_pack(pack_name: String, songs: Dictionary):
	var new_pack = SongPackData.new()
	new_pack.PackName = pack_name
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
	if song_packs.size() == 0 || song_packs.any(func(pack): return pack.PackName == "Original OST") == false:
		add_default_pack()
		set_current_pack("Original OST")
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
	for pack : SongPackData in song_packs:
		if pack.PackName == pack_name:
			current_pack = pack
			on_pack_changed.emit()
			OptionsManager.set_songpack_setting(pack_name)
			print("pack has been set to ", pack_name)
			return
	printerr("No pack found.")

func set_current_pack_by_index(index: int):
	current_pack = song_packs[index]

# Get the list of all song packs
func get_song_packs() -> Array:
	return song_packs

# Play a song from the currently selected pack by its name
func play_song(song_name: String):
	if current_pack:
		for song in current_pack.Songs:
			if song == song_name:
				current_song_id_to_play = song
				_play_song_path(current_pack.Songs[song])
				return
	print("Song not found in the current pack.")

# Stop the currently playing song
func stop_song():
	if audio_stream_player.playing:
		audio_stream_player.stop()

# Private function to handle playing a song from its file path
func _play_song_path(path: String):
	var stream: AudioStream
	var file_extension = path.get_extension().to_lower()
	match file_extension:
		"ogg":
			stream = AudioStreamOggVorbis.load_from_file(path)
		"mp3":
			var file = FileAccess.open(path, FileAccess.READ)
			var sound = AudioStreamMP3.new()
			sound.data = file.get_buffer(file.get_length())
			stream = sound
		"wav":
			var file = FileAccess.open(path, FileAccess.READ)
			var sound = AudioStreamWAV.new()
			sound.data = file.get_buffer(file.get_length())
			stream = sound
		_:
			print("Unsupported file format: ", file_extension)
			return
	if stream != null:
		audio_stream_player.stream = stream
		audio_stream_player.play()
	else:
		print("Failed to load song at path:", path)


func _on_song_pack_changed():
	audio_stream_player.stop()
	play_song(current_song_id_to_play)
