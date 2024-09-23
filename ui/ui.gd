class_name GameplayUI
extends Control

@onready var failure: FailureScreen = $failure
@onready var hud: VBoxContainer = $HUD

func _ready() -> void:
	Game.ui = self

func Loss():
	hud.hide()
	failure.show()
	failure.play_fail()
