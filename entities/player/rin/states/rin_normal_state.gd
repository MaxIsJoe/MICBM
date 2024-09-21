@tool
extends State

@export var bomb_scene: PackedScene = null
@export var max_bombs: int = 1
var bombs: int = max_bombs

func _step(delta: float):
	super(delta)
	tractutate(delta)

func _enter():
	super()
	update_ammo()

func _handle_input(event: InputEvent):
	if event.is_action_pressed("attack"):
		deploy_bomb()

func deploy_bomb():
	if bombs > 0:
		set_state("attacking")
		bombs -= 1
		%reload_timer.start()
	update_ammo()

func gain_bomb():
	bombs += 1
	bombs = min(bombs, max_bombs)
	if bombs < max_bombs:
		%reload_timer.start()
	update_ammo()
	
func update_ammo():
	father.ammo = bombs
	father.on_ammo_change.emit()

func tractutate(delta):
	var traction: Vector2 = Vector2()
	var mods: Array[Modifier] = father.get_modifiers()
	for mod : Modifier in mods:
		if (mod.type.ModifierUse.Restrain): delta -= clamp(delta, 0.5, delta / 2)
	
	if Input.is_action_pressed("move_up"):    traction.y -= 1
	if Input.is_action_pressed("move_down"):  traction.y += 1
	if Input.is_action_pressed("move_left"):  traction.x -= 1
	if Input.is_action_pressed("move_right"): traction.x += 1
	
	traction = traction.normalized()
	father.accelerate(traction, delta)
