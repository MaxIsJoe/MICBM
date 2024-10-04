class_name Options 
extends Node

var options = {
    "master_volume": 1,
    "music_volume": 0.5,
    "sound_volume": 1,
    "fullscreen": false,
    "last_song_pack": "Original OST",
}

var save_path = "user://options.ini"

func _ready():
    if _options_save_file_exists() == false:
        _save_options()
    _load_options()

func _save_options():
    var config = ConfigFile.new()
    for option in options:
        config.set_value(option, "value", options[option])
    config.save(save_path)

func _load_options():
    var config = ConfigFile.new()
    var error = config.load(save_path)
    if error == OK:
        for option in options:
            if config.has_section_key(option, "value"):
                options[option] = config.get_value(option, "value")
    else:
        print("Error loading options: ", error)

func _options_save_file_exists() -> bool:
    return FileAccess.file_exists(save_path)

func set_music_volume_setting(value: float):
    options["music_volume"] = value
    _save_options()

func set_master_volume_setting(value: float):
    options["master_volume"] = value
    _save_options()

func set_sound_volume_setting(value: float):
    options["sound_volume"] = value
    _save_options()

func set_fullscreen_setting(value: bool):
    options["fullscreen"] = value
    _save_options()

func set_songpack_setting(value: String):
    options["last_song_pack"] = value
    _save_options()