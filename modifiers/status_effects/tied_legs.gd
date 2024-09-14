class_name StatusEffectLegsTied
extends StatusEffect


@export var severity: float = 1.0


func activate(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = super(context)
	
	if context.context == context.ctx.ACCELERATION:
		output.value = severity
	
	return output
