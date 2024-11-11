@tool
extends State

@export var speed: float = 2500.0

var last_target_position: Vector2

func _enter():
	$wander_timer.start()
	father.acceleration = 2500
	randomize_wander_location()


func _step(delta: float):
	#FIXME: why wont _step work on this?
	super(delta)
	var relative: Vector2 = father.global_position - last_target_position
	var dir: Vector2 = relative.normalized()
	var target_position: Vector2 = last_target_position + dir
	var to_move: Vector2 = target_position - father.global_position
	var move_dir: Vector2 = to_move.normalized()
	father.accelerate(move_dir, delta)
		

func _on_wander_timer_timeout() -> void:
	randomize_wander_location()

func randomize_wander_location():
	last_target_position = Vector2(randf_range(-65, 65) + father.global_position.x, randf_range(-65, 65) + father.global_position.y)
