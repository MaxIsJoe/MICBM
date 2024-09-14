extends Knockable



func get_collected():
	var new_screen = Game.get_object("upgrade_screen").instantiate()
	Game.deploy_ui_instance(new_screen, Vector2())
	
	queue_free()


func _on_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		get_collected()
