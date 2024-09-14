class_name StatusEffectSlippery
extends StatusEffect


@export var severity: float = 1.0


func activate(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = super(context)
	
	if context.context == context.ctx.FRICTION:
		output.value = severity
	
	return output
