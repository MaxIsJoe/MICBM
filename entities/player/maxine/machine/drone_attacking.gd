extends State

@onready var charge_progress: ProgressBar = $"../../charge-progress"
@export var projectiles: Array[PackedScene]
@export var projectile_speed: float = 800
@export var target_teams: Array[int] = [0, 1, 2]
@export var shooting_ray: RayCast2D
@export var searching_state: State
@export var shooting_timer: Timer


func _on_shooting_timer_timeout():
	if active == false: return
	charge_progress.value -= 10
	var new_projectile = projectiles.pick_random().instantiate()
	var direction: Vector2 = shooting_ray.global_transform.y.normalized()
	new_projectile.velocity = direction * projectile_speed
	new_projectile.teams = target_teams
	Game.deploy_instance(new_projectile, father.global_position)
	if charge_progress.value <= 0:
		father.queue_free()
		return
	var col = shooting_ray.get_collider()
	if col == null:
		set_state(searching_state.name)
	else:
		if col.is_in_group("player") == false or col.is_in_group("enemy") == false:
			set_state(searching_state.name)
