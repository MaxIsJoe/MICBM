extends Upgrade


@export var boost: float = 0.5
@export var boost_per_stack: float = 0.25


func activate(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = super(context)
	
	if context.context == context.ctx.BLAST_RADIUS:
		output.value = boost + boost_per_stack*(stacks - 1)
	
	return output
