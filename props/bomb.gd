extends Knockable


@export var target_teams: Array[int] = [1]

var father: Entity = null
var explosion_radius: float = 96
var explosion_scale: float = 1
var fuse_duration_multiplier: float = 1: set = set_fuse_duration_multiplier


func explode():
	var this_explosion_scale: float = explosion_scale
	if is_instance_valid(father):
		var context = ModifierContext.new()
		context.context = ModifierContext.ctx.BLAST_RADIUS
		this_explosion_scale *= (1 + father.modifier_list.calculate_modifiers(context).value)
	
	var new_explosion = Game.get_object("explosion").instantiate()
	new_explosion.set_target_teams(target_teams)
	new_explosion.scale *= this_explosion_scale
	new_explosion.radius = explosion_radius * this_explosion_scale
	new_explosion.father = father
	Game.deploy_instance(new_explosion, global_position)
	
	queue_free()

func set_fuse_duration_multiplier(what: float):
	fuse_duration_multiplier = what
	%animator.speed_scale = what


func _on_enemy_detector_body_entered(body: Node2D) -> void:
	if body is Enemy:
		explode.call_deferred()
