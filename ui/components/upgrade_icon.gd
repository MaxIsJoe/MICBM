extends Control


var upgrade: Upgrade = null


func set_upgrade(what: Upgrade):
	upgrade = what
	%sprite.texture = what.type.icon
	if what.stacks > 1:
		%quantity.base_text = "x%s" % what.stacks
	else:
		%quantity.base_text = ""
	tooltip_text = "%s\n%s" % [what.type.name, what.type.description]
	
	upgrade.disabled_changed.connect(_on_disabled_changed)
	%cross.visible = upgrade.disabled


func _on_disabled_changed():
	%cross.visible = upgrade.disabled
