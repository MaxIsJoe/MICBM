extends Upgrade


@export var base_numerator: float = 2
@export var base_denominator: float = 20


func activate(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = super(context)
	
	if context is ModifierContextObject and context.context == context.ctx.ENEMY_HIT:
		var extra_stacks: float = stacks - 1
		var this_fraction: float = (base_numerator + extra_stacks) / (base_denominator + extra_stacks)
		if randf() < this_fraction:
			var new_srbm = Game.get_object("srbm").instantiate()
			new_srbm.father = context.father
			Game.deploy_instance(new_srbm, context.object.global_position)
	
	return output
