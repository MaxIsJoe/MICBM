class_name Entity
extends CharacterBody2D


@export var max_speed: float = 200.0
@export var acceleration: float = 2000.0
@export var removal_speed: float = 0.0: set = set_removal_speed
@export var bondage_resistance: float = 1.0
@export var daze_duration: float = 1.0

var modifier_list: ModifierList
var last_hit_by: Entity = null
var daze_time: float = 0.0

signal upgrades_changed
signal status_effects_changed
signal modifiers_changed
signal hit

var father = self

func _init() -> void:
	add_to_group("entities")

func _ready() -> void:
	modifier_list = ModifierList.new()
	modifier_list.name = "modifier_list"
	add_child(modifier_list)
	modifiers_changed.connect(_on_modifiers_changed)
	hit.connect(_on_hit)

func _process(delta: float) -> void:
	frictutate(delta)
	
	if daze_time > 0:
		daze_time -= delta
		if daze_time <= 0:
			update_removal_speed()

func _physics_process(_delta: float) -> void:
	move_and_slide()


func get_modifiers() -> Array[Modifier]:
	return modifier_list.get_modifiers()

func get_upgrades() -> Array[Upgrade]:
	return modifier_list.get_upgrades()

func get_status_effects() -> Array[StatusEffect]:
	return modifier_list.get_status_effects()

func gain_modifier(what: Modifier):
	modifier_list.gain_modifier(what)
	update_removal_speed()
	
	if what is Upgrade:
		upgrades_changed.emit()
		what.tree_exiting.connect(_on_upgrade_slain)
	if what is StatusEffect:
		status_effects_changed.emit()
		what.tree_exiting.connect(_on_status_effect_slain)
	
	modifiers_changed.emit()
	what.get_equipped(self)

func accelerate(dir: Vector2, delta: float):
	velocity += dir * acceleration * delta

func frictutate(delta: float):
	if max_speed > 0:
		var friction: float = acceleration / get_max_speed()
		
		var context: ModifierContext = ModifierContext.new()
		context.context = context.ctx.FRICTION
		var modification := modifier_list.calculate_modifiers(context).value / bondage_resistance
		
		var velocity_decrease: float = friction * delta * (1 - modification)
		velocity_decrease = min(velocity_decrease, 1)
		velocity -= velocity * velocity_decrease
	else:
		velocity = Vector2()

func take_knockback(what: Vector2):
	velocity += what

func take_damage(_what: float):
	pass

func update_removal_speed():
	for i in get_modifiers():
		if i is StatusEffect:
			i.removal_speed = get_removal_speed()

func be_fully_bound():
	pass

func get_max_speed() -> float:
	var max_modification: float = 0.95
	var context: ModifierContext = ModifierContext.new()
	context.context = context.ctx.ACCELERATION
	var modification := modifier_list.calculate_modifiers(context).value / bondage_resistance
	modification = min(modification, max_modification)
	if modification >= max_modification:
		be_fully_bound()
	
	return max_speed * (1-modification)

func get_removal_speed() -> float:
	if daze_time > 0:
		return 0
	
	var context: ModifierContext = ModifierContext.new()
	context.context = context.ctx.REMOVAL_SPEED
	var modification: float = (1 + modifier_list.calculate_modifiers(context).value)
	return removal_speed * modification


func set_removal_speed(what: float):
	removal_speed = what
	update_removal_speed()


func _on_upgrade_slain():
	var emission: Callable = func():
		upgrades_changed.emit()
		modifiers_changed.emit()
	emission.call_deferred()

func _on_status_effect_slain():
	var emission: Callable = func():
		status_effects_changed.emit()
		modifiers_changed.emit()
	emission.call_deferred()

func _on_modifiers_changed():
	update_removal_speed()
	
	var context: ModifierContext = ModifierContext.new()
	context.context = context.ctx.MODIFIERS_CHANGED
	modifier_list.calculate_modifiers(context)

func _on_hit():
	daze_time = daze_duration
	update_removal_speed()
