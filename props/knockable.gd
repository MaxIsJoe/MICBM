class_name Knockable
extends Node2D


@export var friction: float = 0.5
var velocity: Vector2 = Vector2()


func _init() -> void:
	add_to_group("knockable_by_explosion")

func _process(delta: float) -> void:
	position += velocity * delta
	velocity -= velocity * friction * delta
