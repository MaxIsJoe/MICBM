extends State

@export var projectiles: Array[PackedScene]
@export var projectile_speed: float = 200
@export var target_teams: Array[int] = [0, 1, 2]

@onready var shoot_delay: Timer = $shoot_delay
@onready var charge_progress: ProgressBar = $"../../charge-progress"


func _enter():
	super()
	shoot_delay.start()

func shoot_projectile():
	var new_projectile = projectiles.pick_random().instantiate()
	new_projectile.velocity = Vector2(projectile_speed, 0).rotated(randf_range(-360, 360))
	new_projectile.teams = target_teams
	Game.deploy_instance(new_projectile, father.global_position)
	return new_projectile

func _on_shoot_delay_timeout() -> void:
	shoot_projectile()
	charge_progress.value -= 5
	if charge_progress.value <= 0:
		father.queue_free()
