extends Node2D

@export var music: AudioStream = null
@export var player_spawn: Marker2D = null


func _ready() -> void:
	Game.world = self
	if music:
		Music.play_song("Ingame")
	var player = Game.next_player.character_scene.instantiate()
	add_child(player)
	player.global_position = player_spawn.global_position
