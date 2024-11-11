@tool
extends State

@export var speed: float = 19000.0

@export var default_state: State
@export var wander_state: State

var target: Node2D = null
var last_target_dir: Vector2
var count = 0

func _enter():
	super()
	target = Game.player
	father.acceleration = speed
	$ram_time.start()

func _step(delta: float):
	super(delta)
	if count < 70:
		count += 1
		last_target_dir = (target.global_position - father.global_position).normalized()
		return
	if is_instance_valid(target):
		father.accelerate(last_target_dir, delta)

func _on_ram_time_timeout() -> void:
	if father.leash_origin == null:
		set_state(default_state.name)
	else:
		set_state(wander_state.name)

func _on_leashing_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		body.leash_to(father)
		set_state(wander_state.name)