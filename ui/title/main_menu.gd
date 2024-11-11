extends Control


@export var flash_duration: float = 1
@export var imagery_position: Vector2 = Vector2(.5, .5)
@export var pages_holder: Control = null
@export var page_options: Control = null
@export var page_about: Control = null
@export var page_play: Control = null
@export var page_music: Control = null

@onready var background_tile: TextureRect = $"background-tile"

func _ready() -> void:
	pages_holder.position = Vector2(pages_holder.position.x + 1000, pages_holder.position.y)

func _process(_delta: float) -> void:
	%imagery.position = size * imagery_position


func arrive():
	flash()
	
	%buttons.show()
	%links.show()
	%play.grab_focus()
	background_tile.show()
	
	Music.play_song("MainMenu")
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	%subtitle.visible_ratio = 0
	tween.tween_property(%subtitle, "visible_ratio", 1, flash_duration)

func flash():
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	%flash.color = Color(1, 1, 1, 1)
	tween.tween_property(%flash, "color", Color(1, 1, 1, 0), flash_duration)
	
func show_page_section(page_to_show: Control):
	page_about.hide()
	page_options.hide()
	page_play.hide()
	page_music.hide()
	page_to_show.show()
	pages_holder.show()
	var tween = get_tree().create_tween()
	tween.tween_property(pages_holder, "position", $"pos-pages".position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_play_pressed() -> void:
	show_page_section(page_play)
	var tween = get_tree().create_tween()
	for child in page_options.get_children():
		tween_alpha_to_show(tween, child)
		for subchild in child.get_children():
			tween_alpha_to_show(tween, subchild)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_button_down() -> void:
	show_page_section(page_options)
	var tween = get_tree().create_tween()
	for child in page_options.get_children():
		tween_alpha_to_show(tween, child)
		for subchild in child.get_children():
			tween_alpha_to_show(tween, subchild)
			
func _on_about_button_down() -> void:
	show_page_section(page_about)
		
func tween_alpha_to_show(tween: Tween, child: Control):
	var original = child.self_modulate
	child.self_modulate = Color(0, 0, 0, 0)
	tween.tween_property(child, "self_modulate", original, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_custom_music_button_down() -> void:
	show_page_section(page_music)
