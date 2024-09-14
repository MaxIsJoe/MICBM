extends Node2D

@export var music: AudioStream = null
@export var player_spawn: Marker2D = null


func _ready() -> void:
	Game.world = self
	if music:
		GlobalSound.play_music(music)
	var player = Game.next_player_to_spawn.instantiate()
	add_child(player)
	player.global_position = player_spawn.global_position
