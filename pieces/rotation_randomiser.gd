@icon("res://pieces/rotation_randomiser.png")
class_name RotationRandomiser
extends Node


func _ready() -> void:
	get_parent().rotation = randf() * PI*2
