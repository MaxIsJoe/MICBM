extends Marker2D


func activate():
	for i in get_children():
		i.activate()
