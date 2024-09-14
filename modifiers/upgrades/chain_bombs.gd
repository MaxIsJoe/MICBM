extends Upgrade


@export var base_numerator: float = 1
@export var base_denominator: float = 6


func activate(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = super(context)
	
	if context is ModifierContextObject and context.context == context.ctx.ENEMY_SLAIN:
		var extra_stacks: float = stacks - 1
		var this_fraction: float = (base_numerator + extra_stacks) / (base_denominator + extra_stacks)
		if randf() < this_fraction:
			var new_bomb = Game.get_object("bomb").instantiate()
			new_bomb.set_fuse_duration_multiplier(20)
			new_bomb.father = context.father
			new_bomb.velocity = Vector2(randf()*400, 0).rotated(randf() * PI*2)
			Game.deploy_instance(new_bomb, context.object.global_position)
	
	return output
