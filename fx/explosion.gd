extends Node2D


@export var shake_range: float = 960
@export var shake_amount: float = 16
@export var radius: float = 96
@export var object_knockback_force: float = 1000
@export var particles_scene: PackedScene = null

var father: Entity = null: set = set_father


func _ready() -> void:
	post_ready.call_deferred()
	
	if is_instance_valid(Game.camera):
		var distance_squared: float = (Game.camera.global_position - global_position).length_squared()
		var ratio: float = distance_squared / (shake_range*shake_range)
		if ratio < 1:
			Game.shake_cam( shake_amount * (1 - ratio) )


func post_ready():
	knockback_objects()
	deploy_particles()
	GlobalSound.play_sfx_2d("blast", global_position)

func knockback_objects():
	for i in get_tree().get_nodes_in_group("knockable_by_explosion"):
		var relative: Vector2 = i.global_position - global_position
		var length_squared = relative.length_squared()
		if length_squared <= radius*radius and length_squared > 0.01:
			var ratio: float = relative.length() / radius
			i.velocity += relative.normalized() * object_knockback_force * (1 - ratio)

func deploy_particles():
	var new_particles = particles_scene.instantiate()
	Game.deploy_instance(new_particles, global_position)

func set_target_teams(what: Array[int]):
	%hitbox.teams = what

func set_father(what: Entity):
	father = what
	%hitbox.father = what
