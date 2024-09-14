extends Control


@export var shake_magnitude: float = 4.0
@export var shake_reset_speed: float = 8.0
@export var fade_colour: Color = Color(1, 1, 1, 0.75)
@export var fade_angle_degrees: float = 1
@export var fade_scale: float = 0.95
@export var fade_speed: float = 5

var has_setup: bool = false
var base_details_position: Vector2 = Vector2()

signal selected


func _process(delta: float) -> void:
	if %details.pivot_offset == Vector2():
		centre_pivot()
	
	if !has_setup:
		base_details_position = %bac.position
		has_setup = true
	
	if has_focus():
		%bac.position += Vector2(randf()*shake_magnitude, 0).rotated(randf() * PI*2)
		%exhaust.emitting = true
		%details.modulate = %details.modulate.lerp(Color(1, 1, 1, 1), fade_speed*delta)
		%details.rotation = lerp( %details.rotation, -deg_to_rad(fade_angle_degrees), fade_speed*delta )
		%details.scale = %details.scale.lerp( Vector2(1, 1), fade_speed*delta )
	else:
		%exhaust.emitting = false
		%details.modulate = %details.modulate.lerp(fade_colour, fade_speed*delta)
		%details.rotation = lerp( %details.rotation, deg_to_rad(fade_angle_degrees), fade_speed*delta )
		%details.scale = %details.scale.lerp( Vector2(fade_scale, fade_scale), fade_speed*delta )
	%bac.position = %bac.position.lerp(base_details_position, shake_reset_speed * delta)

func _gui_input(event: InputEvent) -> void:
	if Util.is_event_click(event):
		selected.emit()
	if event.is_action_pressed("ui_accept"):
		selected.emit()


func centre_pivot():
	%details.pivot_offset = %details.size / 2

func set_upgrade(what: ModifierType):
	%icon.texture = what.icon
	%title.text = what.name
	%description.text = what.description
