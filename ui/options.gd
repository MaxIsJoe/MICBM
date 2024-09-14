extends Control


func _ready() -> void:
	set_element_values()


func set_element_values():
	%master_slider.value = db_to_linear( AudioServer.get_bus_volume_db(0) )
	%music_slider.value = db_to_linear( AudioServer.get_bus_volume_db(1) )
	%sfx_slider.value = db_to_linear( AudioServer.get_bus_volume_db(2) )
	%fullscreen_button.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN or DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db( 0, linear_to_db(value) )

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db( 1, linear_to_db(value) )

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db( 2, linear_to_db(value) )

func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
