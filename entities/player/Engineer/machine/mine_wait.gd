extends State

var explosion_radius: float = 151
@export var target_teams: Array[int] = [0, 1, 2]

func deploy_bomb():
	var this_explosion_scale: float = 1
	if is_instance_valid(father):
		var context = ModifierContext.new()
		context.context = ModifierContext.ctx.BLAST_RADIUS
		this_explosion_scale *= (1 + father.modifier_list.calculate_modifiers(context).value)
	
	var new_explosion = Game.get_object("explosion").instantiate()
	new_explosion.set_target_teams(target_teams)
	new_explosion.scale *= this_explosion_scale
	new_explosion.radius = explosion_radius * this_explosion_scale
	new_explosion.father = father
	Game.deploy_instance(new_explosion, father.global_position)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if (body.is_in_group("projectile")): 
		return
	else:
		deploy_bomb()
		father.queue_free()
