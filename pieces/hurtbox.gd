class_name Hurtbox
extends Area2D


@export var teams: Array[int] = [1]
@export var invuln_duration := 0.1

var invuln_time := 0.0
var overlapping_hitboxes: Array[Hitbox] = []
var father: Node = null

signal hit


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	if !is_instance_valid(father):
		father = get_parent()
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(6, true)
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(5, true)

func _process(delta: float) -> void:
	invuln_time -= delta
	if invuln_time <= 0:
		if overlapping_hitboxes.size() > 0:
			for i in range(overlapping_hitboxes.size()):
				var this_hitbox: Hitbox = overlapping_hitboxes[i]
				if this_hitbox.active:
					hit.emit(this_hitbox)
					this_hitbox.on_projectile_hit.emit(self)
					this_hitbox.hit_being(father)
					invuln_time = invuln_duration
					break


func is_compatible_hitbox(what: Hitbox) -> bool:
	if !what.repeat_hits and what.previous_hits.has(self):
		return false
	
	for i in what.teams:
		if teams.has(i):
			return true
	return false


func _on_area_entered(what: Area2D):
	if what is Hitbox and !overlapping_hitboxes.has(what) and is_compatible_hitbox(what):
		overlapping_hitboxes.append(what)

func _on_area_exited(what: Area2D):
	if overlapping_hitboxes.has(what):
		overlapping_hitboxes.erase(what)
