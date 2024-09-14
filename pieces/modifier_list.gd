class_name ModifierList
extends Node


func get_modifiers() -> Array[Modifier]:
	var output: Array[Modifier] = []
	
	for i in get_children():
		if i is Modifier: output.append(i)
	
	return output

func get_upgrades() -> Array[Upgrade]:
	var output: Array[Upgrade] = []
	
	for i in get_modifiers():
		if i is Upgrade:
			output.append(i)
	
	return output

func get_status_effects() -> Array[StatusEffect]:
	var output: Array[StatusEffect] = []
	
	for i in get_modifiers():
		if i is StatusEffect:
			output.append(i)
	
	return output

func gain_modifier(what: Modifier):
	if what is Upgrade:
		gain_upgrade(what)
	if what is StatusEffect:
		gain_status_effect(what)

func gain_upgrade(what: Upgrade):
	var existing_upgrades: Array[Modifier] = get_modifier_instance(what.type)
	
	if existing_upgrades.size() > 0:
		existing_upgrades[0].stacks += 1
	else:
		add_child(what)

func gain_status_effect(what: StatusEffect):
	add_child(what)

func has_modifier(what: ModifierType):
	for i in get_children():
		if i.type == what:
			return true
	return false

func get_modifier_instance(what: ModifierType) -> Array[Modifier]:
	var output: Array[Modifier] = []
	
	for i in get_children():
		if i.type == what:
			output.append(i)
	
	return output

func calculate_modifiers(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = ModifierResult.new()
	
	for i in get_modifiers():
		if !i.disabled:
			var this_result: ModifierResult = i.activate(context)
			output = output.combine_with(this_result)
	
	return output
