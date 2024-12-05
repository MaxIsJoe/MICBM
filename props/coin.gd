extends Knockable


@export var acceleration: float = 2000
@export var sfx_pitch_increment: float = 0.1
@export var sfx_pitch_reset_speed: float = 2

var value: float = 1
var target: Node2D = null
var pitch: float = 1.0


func _init():
	super()
	
	add_to_group("coins")

func _process(delta: float) -> void:
	super(delta)
	
	pitch = lerp(pitch, 1.0, sfx_pitch_reset_speed * delta)
	
	if is_instance_valid(target):
		var dir: Vector2 = (target.global_position - global_position).normalized()
		velocity += dir * acceleration * delta


func get_collected():
	Game.get_run().money += value
	var sound = GlobalSound.sfx.get("coin").pick_random()
	var sfx: AudioStreamPlayer = GlobalSound.play_sfx_stream(sound, false)
	sfx.pitch_scale = pitch
	for i in get_tree().get_nodes_in_group("coins"):
		i.pitch += sfx_pitch_increment
	sfx.play()
	queue_free()


func _on_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		get_collected()

func _on_large_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		%large_detector.queue_free()
