@tool
@icon("res://pieces/flippable.png")
class_name Flippable
extends Node2D


@export var flip_on_movement: bool = true
@export var speed_requirement: float = 10
@export var flip_speed: float = -1
@export var scale_multiplier: float = 1: set = set_scale_multiplier

var target_scale: float = 1

var prev_position := Vector2()


func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		var movement := global_position.x - prev_position.x
		if flip_on_movement and abs(movement) >= speed_requirement*delta:
			if movement > 0:
				target_scale = scale_multiplier
			if movement < 0:
				target_scale = -scale_multiplier
		
		flip(delta)
		
		prev_position = global_position


func flip(delta: float):
	if flip_speed < 0:
		scale.x = target_scale
	else:
		scale.x = lerp(scale.x, target_scale, flip_speed * delta)


func set_scale_multiplier(what: float):
	scale_multiplier = what
	
	scale.y = scale_multiplier
	scale.x = sign(scale.x) * scale_multiplier
