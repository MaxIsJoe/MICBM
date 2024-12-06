@tool
extends State

@export var speed: float = 19000.0

@export var default_state: State
@export var wander_state: State

@export var sound_enter_state: AudioStreamPlayer2D
@export var sound_ramming: AudioStreamPlayer2D

@onready var smoke: GPUParticles2D = $"../../smoke"

var target: Node2D = null
var last_target_dir: Vector2
var can_chase: bool = false

func _enter():
	super()
	target = Game.player
	father.acceleration = speed
	father.max_speed = 600
	$ram_time.start()
	smoke.emitting = true
	sound_enter_state.play()
	get_tree().create_timer(1.35).timeout.connect(func(): 
		sound_ramming.play()
		can_chase = true
		last_target_dir = (target.global_position - father.global_position).normalized())

func _exit():
	sound_ramming.stop()
	can_chase = false
	super()

func _step(delta: float):
	super(delta)
	if is_instance_valid(target) && can_chase:
		father.accelerate(last_target_dir, delta)

func _on_ram_time_timeout() -> void:
	if father.leash_origin == null:
		set_state(default_state.name)
	else:
		set_state(wander_state.name)

func _on_leashing_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		body.leash_to(father)
		set_state(wander_state.name)
