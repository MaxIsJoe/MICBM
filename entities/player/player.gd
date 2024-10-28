class_name Player
extends Entity

@export var removal_speed_threshhold: float = 80.0
@export var build_range: float = 768.0

@export var base_camera_zoom: float = 0.5

@export_category("Images")
@export var default_image: Texture2D = null
@export var armbound_image: Texture2D = null
@export var legbound_image: Texture2D = null
@export var bothbound_image: Texture2D = null

var ammo = 0
signal on_ammo_change

func _init():
	super()
	add_to_group("players")

func _ready() -> void:
	super()
	Game.player = self
	LimboConsole.register_command(_on_death_gauge_filled, "die", "Lose")

func _process(delta: float) -> void:
	super(delta)
	
	point_at_silo()
	
	var target_removal_speed: float = 0.0
	if velocity.length_squared() < removal_speed_threshhold * removal_speed_threshhold:
		target_removal_speed = 1.0
	
	if removal_speed != target_removal_speed:
		set_removal_speed(target_removal_speed)
	
	var walk_threshhold: float = max_speed * 0.25
	if velocity.length_squared() >= walk_threshhold * walk_threshhold:
		%visual.play_animation("walk")
	else:
		%visual.play_animation("idle")

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint() and event.is_action_pressed("test"):
		var new_screen = Game.get_object("upgrade_screen").instantiate()
		Game.deploy_ui_instance(new_screen, Vector2())
	
	if event.is_action("ui_end"):
		_on_death_gauge_filled()


func gain_modifier(what: Modifier):
	super(what)
	if what is StatusEffect:
		if what.type.item_sprite != null:
			var new_sprite: Sprite2D = %visual.add_sprite(what.type.item_sprite)
			what.tree_exiting.connect(new_sprite.queue_free)

func point_at_silo():
	var fade_distance: float = 1500
	var nearest_silo: Node2D = Util.get_nearest_group_member("silos", global_position)
	if is_instance_valid(nearest_silo):
		var relative: Vector2 = nearest_silo.global_position - global_position
		var points: PackedVector2Array = PackedVector2Array()
		for i in range(0, 10):
			points.append(relative * i / 10.0)
		%silo_indicator.points = points
		
		var ratio: float = relative.length() / fade_distance
		%silo_indicator.modulate.a = ratio - 1

func set_camera_zoom():
	var this_zoom: float = base_camera_zoom
	
	var context: ModifierContext = ModifierContext.new()
	context.context = context.ctx.CAMERA_ZOOM
	this_zoom += modifier_list.calculate_modifiers(context).value
	
	%cam.target_zoom = Vector2(this_zoom, this_zoom)

func set_image():
	var images: Array[Texture2D] = [default_image, armbound_image, legbound_image, bothbound_image]

	var context: ModifierContext = ModifierContext.new()
	context.context = context.ctx.ACCELERATION
	var bondage_difficuilty = calculate_speed_modification(context);
	
	var legbound: bool = bondage_difficuilty > 0.25
	var armbound: bool = bondage_difficuilty > 0.5
	var bothbound: bool = bondage_difficuilty > 0.7

	var index: int = 0
	if armbound: index += 1
	if legbound: index += 1
	if bothbound: index = images.size() - 1
	%visual.texture = images[index]


func _on_build_timer_timeout() -> void:
	var nearest_silo: Node2D = Util.get_nearest_group_member("silos", global_position)
	if is_instance_valid(nearest_silo):
		var relative = global_position - nearest_silo.global_position
		if relative.length_squared() <= build_range * build_range:
			var context: ModifierContext = ModifierContext.new()
			context.context = context.ctx.BUILD_POWER
			var build_power: float = 1 + modifier_list.calculate_modifiers(context).value
			
			var new_wrench = Game.objects["wrench"].instantiate()
			new_wrench.power *= build_power
			Game.deploy_instance(new_wrench, global_position)

func _on_modifiers_changed():
	super()
	set_image()
	set_camera_zoom()

func _on_death_gauge_filled() -> void:
	if Game.run == null: return
	Engine.time_scale = 0.25
	Game.ui.Loss()
