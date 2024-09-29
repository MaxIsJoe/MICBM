class_name ViberationManager
extends Node

var current_strength: float = 0.0

var current_active_controller: int = 0
var vibe_tick_duration: float = 1.25

func _ready() -> void:
	print(str(Input.get_connected_joypads()))
	var time = Timer.new()
	time.one_shot = false
	time.wait_time = vibe_tick_duration
	time.timeout.connect(_vibe_tick)
	add_child(time)
	time.start()

func Vibe(strength: float):
	current_strength = strength
	current_strength = clampf(current_strength, 0, 1)
	_vibe_tick()

func Feedback(strength: float, duration: float = 0.25):
	Input.start_joy_vibration(current_active_controller, strength, 0, duration)

func _vibe_tick():
	if current_strength <= 0: return
	Input.stop_joy_vibration(current_strength)
	Input.start_joy_vibration(current_active_controller, 
		current_strength if current_strength > 0.75 else 0, # Weak Motter
		current_strength, # Strong Mottor
	 	vibe_tick_duration + 0.1)
	current_strength = current_strength - (current_strength * 0.25)
	if current_strength < 0.005:
		current_strength = 0
	print(current_strength)
