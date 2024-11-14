@tool
extends State

@export var speed: float = 2500.0

var last_target_position: Vector2
@onready var smoke: GPUParticles2D = $"../../smoke"

func _step(delta: float):
	#FIXME: why wont _step work on this?
	super(delta)
	if father.global_position.distance_to(last_target_position) < 5:
		randomize_wander_location()
	var relative: Vector2 = father.global_position - last_target_position
	var dir: Vector2 = relative.normalized()
	var target_position: Vector2 = last_target_position + dir
	var to_move: Vector2 = target_position - father.global_position
	var move_dir: Vector2 = to_move.normalized()
	father.accelerate(move_dir, delta)

func _on_wander_timer_timeout() -> void:
	randomize_wander_location()


func randomize_wander_location():
	last_target_position = Vector2(randf_range(-565, 565) + father.global_position.x, randf_range(-565, 565) + father.global_position.y)

func _on_entered() -> void:
	$wander_timer.start()
	father.acceleration = 2500
	father.max_speed = 175
	randomize_wander_location()
	smoke.emitting = false
