extends Node

var sfx: Dictionary = {
	"blast": [preload("res://audio/sfx/blast0.wav")],
	"coin": [preload("res://audio/sfx/coins0_0.wav"), preload("res://audio/sfx/coins0_1.wav"), preload("res://audio/sfx/coins0_2.wav"), preload("res://audio/sfx/coins0_3.wav"), ]
}

var bus_layout: AudioBusLayout = preload("res://audio/audio_bus.tres")
var gameplay_mixer: int

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioServer.set_bus_layout(bus_layout)
	gameplay_mixer = AudioServer.get_bus_index("Gameplay")

func play_sfx_2d(what: String, where: Vector2) -> SFX2D:
	var new_sfx: SFX2D = SFX2D.new()
	var available_streams: Array = sfx[what]
	new_sfx.stream = available_streams.pick_random()
	new_sfx.max_distance = 1750
	Game.deploy_instance(new_sfx, where)
	return new_sfx
	
func play_sfx_stream(stream: AudioStream, autoplay: bool = true) -> AudioStreamPlayer:
	if (stream == null): return
	var new_sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	new_sfx.stream = stream
	new_sfx.autoplay = autoplay
	new_sfx.finished.connect(new_sfx.queue_free)
	new_sfx.bus = "SFX"
	Game.add_child(new_sfx)
	return new_sfx

func pitch_shift(shift_to: float, time: float):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(AudioServer.get_bus_effect(gameplay_mixer, 0), "pitch_scale", shift_to, time)
	
func lower_bus_volume(bus_index: int, shift_to: float, time: float):
	var tween: Tween = get_tree().create_tween()
	tween.tween_method(change_audio_bus_volume_arrayArg,
		[gameplay_mixer, AudioServer.get_bus_volume_db(gameplay_mixer)],
		[gameplay_mixer, shift_to],
		time)
	
func change_audio_bus_volume(bus_index: int, value: float):
	AudioServer.set_bus_volume_db(bus_index, value)

func change_audio_bus_volume_arrayArg(args: Array):
	AudioServer.set_bus_volume_db(args[0], args[1])
