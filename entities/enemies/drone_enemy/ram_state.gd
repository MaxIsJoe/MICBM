@tool
extends State

@export var speed: float = 9000.0

var target: Node2D = null
var last_target_position: Vector2
var count = 0

func _enter():
	super()
	target = Game.player
	father.acceleration = speed
	$ram_time.start()

func _step(delta: float):
	super(delta)
	if count < 500:
		count += 1
		last_target_position = target.global_position
		return
	if is_instance_valid(target):
		var dir: Vector2 = (last_target_position - father.global_position).normalized()
		father.accelerate(dir, delta)


func _on_ram_time_timeout() -> void:
	if father.leash_origin == null:
		set_state("default")
	else:
		set_state("wander")


func _on_leashing_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		body.leash_to(father)
		set_state("wander")
