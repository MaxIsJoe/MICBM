class_name Enemy
extends Entity


@export var value: float = 1.0
@export var height: float = 128.0
@export var drop_speed: float = 8.0

@export_category("Images")
@export var default_texture: Texture2D = null
@export var semi_texture: Texture2D = null
@export var bound_texture: Texture2D = null

var uber: bool = false


func _init() -> void:
	super()
	add_to_group("enemies")

func _ready() -> void:
	super()
	set_image()
	
	if uber:
		var new_crown = Game.get_object("crown").instantiate()
		add_child(new_crown)
		new_crown.position.y = -128
		modulate = Color(2, 2, 2, 1)


func set_image():
	if get_max_speed() < max_speed * 0.9:
		%visual.texture = semi_texture
		Game.get_run().enemy_restrained()
	else:
		%visual.texture = default_texture

func be_fully_bound():
	super()
	
	var offset = Vector2(randf() * 16, 0).rotated(randf() * PI * 2)
	
	var new_coin = Game.get_object("coin").instantiate()
	new_coin.value = value
	new_coin.velocity = offset * drop_speed
	Game.deploy_instance(new_coin, global_position + offset)
	
	if uber:
		var new_upgrade = Game.get_object("upgrade").instantiate()
		new_upgrade.velocity = -offset * drop_speed
		Game.deploy_instance(new_upgrade, global_position - offset)
	
	var new_corpse = Game.get_object("corpse").instantiate()
	new_corpse.set_texture(bound_texture)
	new_corpse.global_transform = %visual.global_transform
	new_corpse.modulate = %visual.modulate * modulate
	Game.deploy_instance(new_corpse, global_position)
	
	var context: ModifierContextObject = ModifierContextObject.new()
	context.context = context.ctx.ENEMY_SLAIN
	context.father = last_hit_by
	context.object = self
	Game.activate_all_modifiers(context)
	Game.get_run().enemy_restrained()
	release_leash()
	
	queue_free()


func _on_modifiers_changed():
	super()
	set_image()

func _on_hit(_attacker_name):
	super(_attacker_name)
	
	var context: ModifierContextObject = ModifierContextObject.new()
	context.context = context.ctx.ENEMY_HIT
	context.father = last_hit_by
	context.object = self
	Game.activate_all_modifiers(context)
