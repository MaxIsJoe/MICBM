extends Upgrade

@export var chance: float = 10
@export var chance_per_stack: float = 5


func activate(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = super(context)
	if context.context == context.ctx.ENEMY_SLAIN:
		output.value = chance + chance_per_stack * (stacks - 1)
		remove_negative_mod(output, context)
	return output

func remove_negative_mod(output, context):
	if (context.father == null): return
	if (context.father.modifier_list == null): return
	if (randf_range(0, 100) < output.value):
		for mod : Modifier in context.father.modifier_list.get_modifiers():
			if (mod.type.modUse == 1):
				mod.queue_free()
				break
