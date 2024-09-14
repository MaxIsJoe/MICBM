extends Control

@export var texture: Texture2D = null
@export var icon_spacing: Vector2 = Vector2(32, 32)
@export var auto_target_player: bool = true

var target: Player = null


func _process(_delta: float) -> void:
	if auto_target_player:
		if !is_instance_valid(target) and is_instance_valid(Game.player):
			set_target(Game.player)


func clear_icons():
	var icons: Array[Node] = get_children()
	
	for i in icons:
		remove_child(i)
		i.queue_free()

func update_icons():
	clear_icons()
	
	for i in range(target.ammo):
		var new_icon: TextureRect = TextureRect.new()
		new_icon.texture = texture
		add_child(new_icon)
		new_icon.position = icon_spacing * (get_child_count() - 1)


func set_target(what: Player):
	if is_instance_valid(target):
		target.on_ammo_change.disconnect(_on_bombs_changed)
	
	target = what
	update_icons()
	
	if is_instance_valid(target):
		target.on_ammo_change.connect(_on_bombs_changed)


func _on_bombs_changed():
	update_icons()
