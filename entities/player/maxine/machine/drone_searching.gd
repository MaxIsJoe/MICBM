extends State

@export var shooting_ray: RayCast2D
@export var attacking_stage: State
var target_go_to: Vector2
var player_cache: Entity

func _enter():
	super()
	player_cache = get_tree().get_first_node_in_group("player")
	target_go_to = player_cache.global_position

func _step(delta):
	super(delta)
	shooting_ray.rotate(delta * 6)
	if father.global_position.distance_to(target_go_to) >= 12:
		var move_dir: Vector2 = (target_go_to - father.global_position).normalized()
		father.accelerate(move_dir, delta)
	else:
		target_go_to = get_tree().get_first_node_in_group("player").global_position + Vector2(randf_range(-25, 25), randf_range(-25, 25))
	var col = shooting_ray.get_collider()
	if col != null:
		if col.is_in_group("player") or col.is_in_group("enemy"):
			set_state(attacking_stage.name)
