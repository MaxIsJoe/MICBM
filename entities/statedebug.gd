extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velspeed = get_parent().velocity
	text = $"../fsm".state_name + "\n" +str(velspeed)
