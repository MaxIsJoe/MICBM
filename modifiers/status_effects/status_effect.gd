class_name StatusEffect
extends Modifier


@export var max_duration: float = 5.0
@export var duration: float = 5.0

var removal_speed: float = 1.0


func _process(delta: float) -> void:
	if duration > 0:
		max_duration = max(duration, max_duration)
		duration -= removal_speed * delta
		if duration <= 0:
			if father is Player:
				Game.get_run().add_time_restraint_removed()
			queue_free()
