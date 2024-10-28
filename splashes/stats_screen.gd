extends Control

@onready var panel: Panel = $panel
@onready var stat_list: VBoxContainer = $panel/content/stat_list


func ShowStats():
	for child in stat_list.get_children():
		child.queue_free()
		
	var run: Run = Game.get_run()
	for stat_key in run.game_stats:
		var value = run.game_stats[stat_key]
		var stat_container = HBoxContainer.new()
		stat_list.add_child(stat_container)

		# Create label for the stat key
		var key_label = Label.new()
		key_label.text = stat_key
		stat_container.add_child(key_label)

		# Create label for the stat value
		var value_label = Label.new()
		value_label.text = str(value)
		stat_container.add_child(value_label)
