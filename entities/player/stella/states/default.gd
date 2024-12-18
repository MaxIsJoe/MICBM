@tool
extends State

@export var projectile_scenes: Array[PackedScene] = []
@export var sound_attack: AudioStreamPlayer2D
@export var target_teams: Array[int] = [0, 1, 2]
@export var max_ammo: int = 6
@export var projectile_throw_speed: float = 2.0
@export var reload_time: float = 5
var current_ammo: int = max_ammo


func _step(delta: float):
	super(delta)
	tractutate(delta)

func _enter():
	super()
	update_ammo()

func _handle_input(event: InputEvent):
	if event.is_action_pressed("attack"):
		attack()

func attack():
	if current_ammo > 0:
		var new_bomb = projectile_scenes.pick_random().instantiate()
		new_bomb.velocity = father.velocity * projectile_throw_speed
		new_bomb.father = father
		new_bomb.scale += Vector2(0.5, 0.5)
		new_bomb.penetrations = 4
		new_bomb.set_target_teams(target_teams)
		new_bomb.on_projectile_hit.connect(_explode_on_hit)
		Game.deploy_instance(new_bomb, father.global_position)
		current_ammo -= 1
		if %reload_timer.is_stopped():
			%reload_timer.start()
		if (sound_attack != null && sound_attack.stream != null): sound_attack.play()
	update_ammo()

func gain_ammo():
	current_ammo += 1
	current_ammo = min(current_ammo, max_ammo)
	if current_ammo < max_ammo:
		%reload_timer.start()
	update_ammo()
	
func update_ammo():
	father.ammo = current_ammo
	father.on_ammo_change.emit()

func tractutate(delta):
	var traction: Vector2 = Vector2()
	
	if Input.is_action_pressed("move_up"): traction.y -= 1
	if Input.is_action_pressed("move_down"): traction.y += 1
	if Input.is_action_pressed("move_left"): traction.x -= 1
	if Input.is_action_pressed("move_right"): traction.x += 1
	
	traction = traction.normalized()
	father.accelerate(traction, delta)


func _on_reload_timer_timeout() -> void:
	%reload_timer.wait_time = reload_time
	gain_ammo()

func _explode_on_hit(_this_hitbox):
	if %reload_timer.time_left >= 0.25:
		%reload_timer.start(%reload_timer.time_left - (%reload_timer.time_left * 0.55))
