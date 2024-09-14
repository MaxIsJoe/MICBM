extends HBoxContainer


@export var icon_scene: PackedScene = null
@export var auto_target_player: bool = false

var target: Entity = null


func _process(_delta: float) -> void:
	if auto_target_player:
		if is_instance_valid(Game.player) and !is_instance_valid(target):
			set_target(Game.player)


func clear_icons():
	for i in get_children():
		i.queue_free()

func add_icons():
	clear_icons()
	for i in target.get_upgrades():
		add_icon(i)

func add_icon(what: Upgrade):
	var new_icon = icon_scene.instantiate()
	new_icon.set_upgrade(what)
	add_child(new_icon)

func set_target(what: Entity):
	if is_instance_valid(target):
		target.upgrades_changed.disconnect(_on_upgrades_changed)
	
	target = what
	
	if is_instance_valid(target):
		target.upgrades_changed.connect(_on_upgrades_changed)


func _on_upgrades_changed():
	add_icons()
