extends Control

@export var machines: Array[PackedScene]
@export var buildItem: PackedScene

@onready var build_list: VBoxContainer = $buildList

var input_requirements: Dictionary = {}
var current_inputs: Dictionary = {}

signal building_done(machine_to_build: PackedScene)
signal input_happened(keys: Dictionary)


func _input(event: InputEvent) -> void:
	if input_requirements.size() == 0: return
	if event is InputEventKey and event.is_pressed():
		var input_string = event_to_input_string(event)
		for build_item in current_inputs.keys():
			input_for_build_item(build_item, input_string)
	elif event is InputEventJoypadMotion:
		var input_string = joypad_motion_to_input_string(event)
		for build_item in current_inputs.keys(): #TODO: FIX THIS
			input_for_build_item(build_item, input_string)


func event_to_input_string(event: InputEventKey) -> String:
	if event.keycode == KEY_W:
		return "move_up"
	elif event.keycode == KEY_S:
		return "move_down"
	elif event.keycode == KEY_A:
		return "move_left"
	elif event.keycode == KEY_D:
		return "move_right"
	return ""
	
# Helper function to convert InputEventJoypadMotion to a string (e.g., "joystick_left", "joystick_right")
func joypad_motion_to_input_string(event: InputEventJoypadMotion) -> String:
	if event.axis == JOY_AXIS_LEFT_Y and event.axis_value < -0.4:
		return "move_up"
	elif event.axis == JOY_AXIS_LEFT_Y and event.axis_value > 0.4:
		return "move_down"
	elif event.axis == JOY_AXIS_LEFT_X and event.axis_value < -0.4:
		return "move_left"
	elif event.axis == JOY_AXIS_LEFT_X and event.axis_value > 0.4:
		return "move_right"
	return ""

func generate_new_inputs():
	machines.shuffle()
	current_inputs.clear()
	input_requirements.clear()
	for machine in machines:
		var machine_name: String = ""
		var temp = machine.instantiate()
		machine_name = temp.name
		var new_build_item = buildItem.instantiate()
		var required_inputs: Array[String] = []
		for i in range(randi() % 3 + 2):  
			required_inputs.append(get_random_input())
		input_requirements[new_build_item] = required_inputs
		current_inputs[new_build_item] = []
		build_list.add_child(new_build_item)
		new_build_item.setup(required_inputs, machine_name, machine, input_happened)
		temp.queue_free()

func get_random_input() -> String:
	var possible_inputs = ["move_up", "move_down", "move_left", "move_right"]
	return possible_inputs[randi() % possible_inputs.size()]

func input_for_build_item(build_item, input: String):
	if input_requirements.size() == 0: return
	if build_item in current_inputs:
		var expected_inputs = input_requirements[build_item]
		var current_sequence = current_inputs[build_item]
		current_sequence.append(input)
		if current_sequence == expected_inputs:
			current_sequence.clear()
			building_done.emit(build_item.machine_scene)
			input_requirements.clear()
			for item in build_list.get_children():
				item.queue_free()
			input_done()
			return
		for i in range(current_sequence.size()): # Resetting Input
			if current_sequence[i] != expected_inputs[i]:
				current_sequence.clear()
	input_done()

func input_done():
	input_happened.emit(current_inputs)

func _on_player_input_received(input: String):
	for build_item in current_inputs.keys():
		input_for_build_item(build_item, input)
