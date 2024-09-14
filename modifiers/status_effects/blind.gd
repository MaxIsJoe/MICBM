class_name StatusEffectBlind
extends StatusEffect


@export var severity: float = 0.2


func activate(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = super(context)
	
	if context.context == context.ctx.CAMERA_ZOOM:
		output.value = severity
	
	return output
