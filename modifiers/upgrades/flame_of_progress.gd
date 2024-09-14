extends Upgrade


@export var base_numerator: float = 5
@export var base_denominator: float = 300


func activate(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = super(context)
	
	if context is ModifierContextObject and context.context == context.ctx.ENEMY_SLAIN:
		var extra_stacks: float = stacks - 1
		var this_fraction: float = (base_numerator + extra_stacks) / (base_denominator + extra_stacks)
		if randf() < this_fraction:
			var new_bomb = Game.get_object("upgrade").instantiate()
			new_bomb.velocity = Vector2(randf()*400, 0).rotated(randf() * PI*2)
			Game.deploy_instance(new_bomb, context.object.global_position)
	
	return output
