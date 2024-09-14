@icon("res://pieces/rotator_forward.png")
class_name RotatorForward
extends Node


@export var speed_requirement: float = 20
@export var rotation_speed: float = -1
@export var offset_degrees: float = 0

var father: Node2D = null
var previous_position: Vector2 = Vector2()
var target_rotation: float = 0


func _ready() -> void:
	if get_parent() is Node2D:
		father = get_parent()
		previous_position = father.global_position
	else:
		push_warning("RotatorForward is a child of %s, which is not a Node2D" % get_parent())
		queue_free()

func _process(delta: float) -> void:
	var movement: Vector2 = father.global_position - previous_position
	
	var required_step: float = speed_requirement * delta
	if movement.length_squared() >= required_step*required_step:
		target_rotation = movement.angle() + deg_to_rad(offset_degrees)
	
	if rotation_speed < 0:
		father.global_rotation = target_rotation
	else:
		father.global_rotation = lerp_angle(father.global_rotation, target_rotation, rotation_speed*delta)
	
	previous_position = father.global_position

