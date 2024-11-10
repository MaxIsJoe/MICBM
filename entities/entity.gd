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
signal on_projectile_hit(_attacker_name)

@export_category("Leash")
var leash_origin: CharacterBody2D = null
var leash_line: Line2D
@export var leash_max_distance: float = 200.0
@export var pull_strength: float = 10.0
@export var rope_wave_frequency: float = 5.0 # Controls the frequency of the rope wave
@export var rope_wave_amplitude: float = 5.0 # Controls the height of the wave
@export var rope_segments: int = 20 # Number of segments in the rope

var father = self

func _init() -> void:
	add_to_group("entities")

func _ready() -> void:
	modifier_list = ModifierList.new()
	modifier_list.name = "modifier_list"
	add_child(modifier_list)
	modifiers_changed.connect(_on_modifiers_changed)
	on_projectile_hit.connect(_on_hit)
	leash_line = Line2D.new()
	leash_line.default_color = Color(1, 1, 1) # White color for the leash line
	leash_line.width = 3
	add_child(leash_line)

func _process(delta: float) -> void:
	frictutate(delta)
	
	if daze_time > 0:
		daze_time -= delta
		if daze_time <= 0:
			update_removal_speed()

func _physics_process(_delta: float) -> void:
	move_and_slide()
	if is_instance_valid(leash_origin):
		# Calculate the distance to the leash origin
		var distance = position.distance_to(leash_origin.position)
		if distance > leash_max_distance:
			var direction = (leash_origin.position - position).normalized()
			var pull_force = direction * (distance - leash_max_distance) * pull_strength
			velocity += pull_force * _delta
			update_rope_visual(distance)
		else:
			leash_line.clear_points()
	else:
		leash_line.clear_points()
			
func update_rope_visual(distance):
	# Clear existing points and calculate rope segment spacing
	leash_line.clear_points()
	var direction = (leash_origin.position - position).normalized()
	var scaled_wave_amplitude = min(rope_wave_amplitude, distance / rope_segments)
	# Generate rope points with a sine wave offset
	for i in range(rope_segments + 1):
		var t = float(i) / rope_segments # Normalize segment position between 0 and 1
		var point_position = position.lerp(leash_origin.position, t)
		var perpendicular = Vector2(-direction.y, direction.x)
		var wave_offset = perpendicular * sin(t * rope_wave_frequency * PI * 2) * scaled_wave_amplitude
		leash_line.add_point(point_position + wave_offset - global_position)


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
		what.father = self
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
	var modification := calculate_speed_modification(context)
	modification = min(modification, max_modification)
	if modification >= max_modification:
		be_fully_bound()
	
	return max_speed * (1 - modification)

func calculate_speed_modification(context: ModifierContext) -> float:
	return modifier_list.calculate_modifiers(context).value / bondage_resistance

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

# Function to set the leash origin
func leash_to(origin: CharacterBody2D):
	leash_origin = origin

# Function to release the leash
func release_leash():
	leash_origin = null
	leash_line.clear_points()

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

func _on_hit(_attacker_name):
	daze_time = daze_duration
	update_removal_speed()
