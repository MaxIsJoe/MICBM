extends Node


var sfx: Dictionary = {
	"blast": [preload("res://audio/sfx/blast0.wav")],
	"coin": [preload("res://audio/sfx/coins0_0.wav"), preload("res://audio/sfx/coins0_1.wav"), preload("res://audio/sfx/coins0_2.wav"), preload("res://audio/sfx/coins0_3.wav"), ]
}

var current_music: MusicPlayer = null
var bus_layout: AudioBusLayout = preload("res://audio/audio_bus.tres")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioServer.set_bus_layout(bus_layout)


func play_sfx_2d(what: String, where: Vector2) -> SFX2D:
	var new_sfx: SFX2D = SFX2D.new()
	var available_streams: Array = sfx[what]
	new_sfx.stream = available_streams.pick_random()
	Game.deploy_instance(new_sfx, where)
	return new_sfx

func play_music(what: AudioStream):
	var new_music = MusicPlayer.new()
	new_music.stream = what
	if is_instance_valid(current_music):
		current_music.queue_free()
	current_music = new_music
	add_child(new_music)

func stop_music():
	if is_instance_valid(current_music):
		current_music.stop()
