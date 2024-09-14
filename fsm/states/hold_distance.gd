@tool
extends State


@export var target_distance: float = 400.0
@export var auto_target_player: bool = true
@export var precision: float = 32.0
@export var walk_animation: String = ""

var target: Node2D = null


func _step(delta: float):
	super(delta)
	
	if auto_target_player and !is_instance_valid(target):
		target = Game.player
	
	if is_instance_valid(target):
		var relative: Vector2 = father.global_position - target.global_position
		var dir: Vector2 = relative.normalized()
		var target_position: Vector2 = target.global_position + dir * target_distance
		
		var to_move: Vector2 = target_position - father.global_position
		if to_move.length_squared() > precision*precision:
			var move_dir: Vector2 = to_move.normalized()
			father.accelerate(move_dir, delta)
		
		var walk_threshhold: float = father.max_speed * 0.25
		if father.velocity.length_squared() > walk_threshhold*walk_threshhold:
			fsm.play_animation(walk_animation)
		else:
			fsm.play_animation(animation)
