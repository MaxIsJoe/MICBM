extends Control


var status_effect: StatusEffect = null: set = set_status_effect


func _process(_delta: float) -> void:
	if (status_effect == null): return
	%bac.max_value = status_effect.max_duration
	%bac.value = status_effect.duration


func set_status_effect(what: StatusEffect):
	status_effect = what
	%sprite.texture = what.type.icon
	tooltip_text = "%s\n%s" % [what.type.name, what.type.description]
