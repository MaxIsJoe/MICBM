extends Marker2D


@export var projectile_scene: PackedScene = null
@export var projectile_speed: float = 400.0

@export var parent: Entity
@export var attackSound: AudioStreamPlayer2D

func activate():
	var new_projectile = projectile_scene.instantiate()
	
	new_projectile.velocity = Vector2(projectile_speed, 0).rotated(global_rotation)
	new_projectile.father = parent
	Game.deploy_instance(new_projectile, global_position)
	if (attackSound != null):
		if (attackSound.stream != null): attackSound.play()
	
	return new_projectile
