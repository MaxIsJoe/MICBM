extends StatusEffect


var target_upgrade: Upgrade = null


func get_equipped(by: Entity):
	super(by)
	
	var upgrades: Array[Upgrade] = by.get_upgrades()
	if upgrades.size() > 0:
		target_upgrade = upgrades.pick_random()
		target_upgrade.disabled = true

func activate(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = super(context)
	
	if context.context == context.ctx.MODIFIERS_CHANGED:
		if is_instance_valid(target_upgrade):
			target_upgrade.disabled = true
	
	return output

func get_unequipped(_by):
	if is_instance_valid(target_upgrade):
		target_upgrade.disabled = false
