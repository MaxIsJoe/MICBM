extends Node2D


@export var limit: float = 6
@export var fill_speed: float = 1
@export var shake_speed: float = 4
@export var unshake_speed: float = 2
@export var fill_amount: float = 0.99

var value: float = 0
var actual_value: float = 0
var target: Entity = null

signal filled


func _ready() -> void:
	identify_nearest_target()

func _process(delta: float) -> void:
	actual_value = lerp(actual_value, value, fill_speed*delta)
	var ratio: float = actual_value / limit
	
	%gauge.value = actual_value
	%gauge.max_value = limit
	%gauge.modulate.a = ratio
	
	position = position + Vector2(randf()*shake_speed*ratio, 0).rotated(randf() * PI*2)
	position = position.lerp(Vector2(), unshake_speed*delta)
	
	if ratio > fill_amount:
		filled.emit()


func identify_nearest_target():
	var this_target: Node = get_parent()
	while !(this_target == get_viewport()):
		if this_target is Entity:
			set_target(this_target)
			break
		
		this_target = this_target.get_parent()

func set_target(what: Entity):
	if is_instance_valid(target):
		target.modifiers_changed.disconnect(_on_target_modifiers_changed)
	
	target = what
	
	if is_instance_valid(target):
		target.modifiers_changed.connect(_on_target_modifiers_changed)


func _on_target_modifiers_changed():
	value = target.get_status_effects().size()
