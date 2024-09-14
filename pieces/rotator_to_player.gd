class_name RotatorToPlayer
extends Node


@export var rotation_speed: float = -1
@export var offset_degrees: float = 0


func _process(delta: float) -> void:
	var father: Node2D = get_parent()
	if father and is_instance_valid(Game.player):
		var relative: Vector2 = Game.player.global_position - father.global_position
		var angle: float = relative.angle() + deg_to_rad(offset_degrees)
		
		if rotation_speed < 0:
			father.global_rotation = angle
		else:
			father.global_rotation = lerp_angle(father.global_rotation, angle, rotation_speed*delta)
