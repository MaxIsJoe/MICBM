extends Control

@export var texture: Texture2D = null
@export var icon_spacing: Vector2 = Vector2(32, 32)
@export var auto_target_player: bool = true
@onready var number_bg: ColorRect = $number_bg
@onready var ammo_count: Label = $number_bg/ammo_count
@onready var bomb_holder: Control = $bomb_holder

var target: Player = null

func _process(_delta: float) -> void:
	if auto_target_player:
		if !is_instance_valid(target) and is_instance_valid(Game.player):
			set_target(Game.player)

func clear_icons():
	var icons: Array[Node] = bomb_holder.get_children()
	
	for i in icons:
		bomb_holder.remove_child(i)
		i.queue_free()

func update_icons():
	clear_icons()
	var ammo_to_display = min(target.ammo, 3)
	
	for i in range(ammo_to_display):
		var new_icon: TextureRect = TextureRect.new()
		new_icon.texture = texture
		bomb_holder.add_child(new_icon)
		new_icon.position = icon_spacing * i
		
	if target.ammo > 3:
		number_bg.show()
		ammo_count.text = str(target.ammo)
	else:
		number_bg.hide()

func set_target(what: Player):
	if is_instance_valid(target):
		target.on_ammo_change.disconnect(_on_bombs_changed)
	
	target = what
	update_icons()
	
	if is_instance_valid(target):
		target.on_ammo_change.connect(_on_bombs_changed)

func _on_bombs_changed():
	update_icons()
