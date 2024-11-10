class_name FailureScreen
extends Control

@onready var stats: Control = $Stats
@onready var text_holder: VBoxContainer = $text_holder
@onready var label: CentredLabel = $text_holder/label
@onready var animator: AnimationPlayer = $animator
var showing: bool = false

func _on_egress_pressed() -> void:
	Engine.time_scale = 1
	GlobalSound.pitch_shift(1, 1)
	GlobalSound.lower_bus_volume(AudioServer.get_bus_index("Gameplay"), 0, 0.25)
	get_tree().change_scene_to_file("res://ui/title/main_menu.tscn")

func play_fail():
	if (showing): return
	showing = true
	label.text = Game.next_player.loss_text
	GlobalSound.pitch_shift(Engine.time_scale, 0.25)
	GlobalSound.lower_bus_volume(AudioServer.get_bus_index("Gameplay"), -32, 1.25)
	animator.play("arrive")
	$Stats.ShowStats()


func _on_continue_button_down() -> void:
	text_holder.hide()
	stats.show()
	$stats_anim.play("show")
