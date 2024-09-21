@tool
extends State

@export var hit: PackedScene
@export var marker: CharacterBody2D
@export var original_state: State
@export var target_teams: Array[int] = [1]
var explosion_radius: float = 121

func _step(delta: float):
	super(delta)
	tractutate(delta)
	
func _handle_input(event: InputEvent):
	if event.is_action_pressed("attack"):
		deploy_bomb()
		
func deploy_bomb():
	var this_explosion_scale: float = 1
	if is_instance_valid(father):
		var context = ModifierContext.new()
		context.context = ModifierContext.ctx.BLAST_RADIUS
		this_explosion_scale *= (1 + father.modifier_list.calculate_modifiers(context).value)
	
	var new_explosion = Game.get_object("explosion").instantiate()
	new_explosion.set_target_teams(target_teams)
	new_explosion.scale *= this_explosion_scale
	new_explosion.radius = explosion_radius * this_explosion_scale
	new_explosion.father = father
	Game.deploy_instance(new_explosion, marker.global_position)
	await get_tree().create_timer(0.09).timeout
	set_state(original_state.name)

func _enter():
	super()
	marker.show()
	
func _exit():
	super()
	marker.hide()
	marker.position = Vector2.ZERO
	
func tractutate(delta):
	var traction: Vector2 = Vector2()
	
	if Input.is_action_pressed("move_up"):    traction.y -= 1
	if Input.is_action_pressed("move_down"):  traction.y += 1
	if Input.is_action_pressed("move_left"):  traction.x -= 1
	if Input.is_action_pressed("move_right"): traction.x += 1
	
	traction = traction.normalized()
	marker.accelerate(traction, delta)
