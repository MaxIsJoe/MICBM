extends State

@export var speed: float = 2500.0

var target: Node2D = null
var last_target_position: Vector2
var count = 0

func _enter():
	$wander_timer.start()
	father.acceleration = 2500


func _step(delta: float):
	super(delta)
	var dir: Vector2 = (last_target_position - father.global_position).normalized()
	father.accelerate(dir, delta)


func _on_wander_timer_timeout() -> void:
	last_target_position = Vector2(randf_range(-65, 65) + father.global_position.x, randf_range(-65, 65) + father.global_position.y)
