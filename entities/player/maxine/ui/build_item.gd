extends ColorRect

@onready var label: Label = $label
@onready var inputshow: HBoxContainer = $inputshow
@onready var controlls_holder: Control = $"controlls-holder"

var required_steps: Array[String]
var arrows: Array[Node]
var machine_scene: PackedScene

func setup(steps: Array[String], item_name: String, scene: PackedScene, inputevent):
	arrows = $"controlls-holder".get_children()
	required_steps = steps
	label.text = item_name.capitalize()
	machine_scene = scene
	inputevent.connect(sequence_check)
	for step in steps:
		for arrow in arrows:
			if arrow.name == step:
				var new = arrow.duplicate()
				inputshow.add_child(new)
				
func sequence_check(keys: Dictionary):
	for arrow in inputshow.get_children():
		arrow.modulate = Color("ffffff")  # Default color (white)
	for key in keys.values():
		var m = true  # Flag to track if the input matches the pattern
		for i in range(len(key)):
			if i >= inputshow.get_child_count():
				m = false  # If more inputs than arrows, mismatch
				break
			var input = key[i]
			var arrow = inputshow.get_child(i)
			# Check if arrow name matches the input
			if arrow.name == input:
				arrow.modulate = Color("c60043")  # Correct input color
			else:
				m = false  # If input doesn't match, set mismatch flag
				break

		# If there's a mismatch, reset all arrows back to default color
		if not m:
			for arrow in inputshow.get_children():
				arrow.modulate = Color("ffffff")
			break  # Exit the loop, as the sequence doesn't match
