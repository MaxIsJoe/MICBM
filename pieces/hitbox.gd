class_name Hitbox
extends Area2D


@export var teams: Array[int] = [0]
@export var radial_knockback := 500.0
@export var directional_knockback := Vector2()
@export var active := true
@export var repeat_hits: bool = false
@export var status_effects: Array[ModifierType] = []

var previous_hits: Array[Hurtbox] = []
var father: Entity = null

signal on_projectile_hit

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_layer_value(5, true)
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(6, true)


func get_overlapping_hurtboxes():
	var output: Array[Hurtbox] = []
	
	for i in get_overlapping_areas():
		if i is Hurtbox:
			if i.is_compatible_hitbox(self):
				output.append(i)
	
	return output

func hit_being(what):
	var attacker = "Unknown"
	for i in status_effects:
		what.gain_modifier(i.instantiate())
	
	if is_instance_valid(father):
		what.last_hit_by = father
	var direction = (what.global_position - global_position).normalized()
	var this_radial_knockback = radial_knockback * direction
	var this_directional_knockback = directional_knockback.rotated(global_rotation)
	what.take_knockback(this_radial_knockback + this_directional_knockback)
	
	what.on_projectile_hit.emit(attacker)

func set_target_teams(what: Array[int]):
	teams = what
