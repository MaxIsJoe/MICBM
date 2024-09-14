extends Control


@export var upgrade_panel_scene: PackedScene = null
@export var upgrades: ResourceGroup = null

var upgrade_count: int = 3
var reroll_cost: float = 8
var reroll_cost_increase: float = 2


func _init() -> void:
	add_to_group("pausers")

func _ready() -> void:
	deploy_upgrades()
	set_reroll_text()
	Game.update_pause_status()

func _exit_tree() -> void:
	remove_from_group("pausers")
	Game.update_pause_status.call_deferred()


func deploy_upgrades():
	clear_upgrades()
	for i in upgrade_count:
		choose_random_upgrade()
	connect_upgrades()

func choose_random_upgrade():
	var valid_upgrades: Array[UpgradeType] = []
	var total_weight: float = 0
	
	for this_upgrade in upgrades.load_all():
		if this_upgrade is UpgradeType:
			valid_upgrades.append(this_upgrade)
			total_weight += this_upgrade.weight
	
	var roll: float = randf() * total_weight
	for this_upgrade in valid_upgrades:
		roll -= this_upgrade.weight
		if roll <= 0:
			add_upgrade(this_upgrade)
			break

func clear_upgrades():
	var these_upgrades = %upgrades.get_children()
	for i in these_upgrades:
		i.queue_free()
		%upgrades.remove_child(i)

func add_upgrade(what: UpgradeType):
	var new_panel = upgrade_panel_scene.instantiate()
	new_panel.set_upgrade(what)
	new_panel.selected.connect(_on_option_pressed.bind(what))
	%upgrades.add_child(new_panel)

func set_reroll_text():
	%reroll.text = "Reroll: €%s" % reroll_cost
	%reroll.disabled = Game.get_run().money < reroll_cost

func connect_upgrades():
	var these_upgrades: Array[Control] = []
	
	for i in %upgrades.get_children():
		if i is Control:
			these_upgrades.append(i)
	
	if these_upgrades.size() > 0:
		var main_chain: Array[Control] = these_upgrades.duplicate()
		main_chain.append(%reroll)
		main_chain.append(%none)
		
		# Main connections up and down between elements
		for i in range(main_chain.size()):
			var this_element: Control = main_chain[i]
			var next_element: Control = main_chain[wrapi(i+1, 0, main_chain.size())]
			var this_path: NodePath = next_element.get_path_to(this_element)
			var next_path: NodePath = this_element.get_path_to(next_element)
			
			this_element.focus_next = next_path
			next_element.focus_previous = this_path
			this_element.focus_neighbor_bottom = next_path
			next_element.focus_neighbor_top = this_path
		
		# Left and right between buttons
		%reroll.focus_neighbor_left = %reroll.get_path_to(%none)
		%reroll.focus_neighbor_right = %reroll.get_path_to(%none)
		%none.focus_neighbor_left = %none.get_path_to(%reroll)
		%none.focus_neighbor_right = %none.get_path_to(%reroll)
		
		%reroll.focus_next = %reroll.get_path_to(%none)
		%none.focus_previous = %none.get_path_to(%reroll)
		
		# Unusual connections between buttons and upgrades
		%none.focus_neighbor_top = %none.get_path_to(these_upgrades[-1])
		%reroll.focus_neighbor_bottom = %reroll.get_path_to(these_upgrades[0])
		these_upgrades[0].focus_previous = these_upgrades[0].get_path_to(%reroll)
		these_upgrades[0].focus_neighbor_top = these_upgrades[0].get_path_to(%reroll)
		
		these_upgrades[0].grab_focus()


func _on_option_pressed(what: UpgradeType):
	Game.player.gain_modifier(what.instantiate())
	queue_free()

func _on_none_pressed() -> void:
	queue_free()

func _on_reroll_pressed() -> void:
	deploy_upgrades()
	Game.get_run().money -= reroll_cost
	reroll_cost += reroll_cost_increase
	set_reroll_text()
