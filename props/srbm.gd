extends Node2D


@export var turn_speed: float = 10
@export var move_speed: float = 800
@export var target_teams: Array[int] = [1]

var armed: bool = false
var velocity: Vector2 = Vector2()
var nearest_target: Entity = null
var father: Entity = null


func _ready() -> void:
	velocity = Vector2(move_speed, 0).rotated(randf() * PI*2)
	rotation = velocity.angle()

func _process(delta: float) -> void:
	position += velocity * delta
	
	if armed:
		if is_instance_valid(nearest_target):
			var turn_step: float = turn_speed * delta
			var relative: Vector2 = nearest_target.global_position - global_position
			var dir = relative.angle()
			var change: float = angle_difference(velocity.angle(), dir)
			if abs(change) > turn_step:
				velocity = velocity.rotated( turn_step * sign(change) )
				rotation = velocity.angle()
		else:
			nearest_target = Util.get_nearest_group_member("enemies", global_position)


func explode():
	var new_explosion = Game.get_object("explosion").instantiate()
	new_explosion.set_target_teams(target_teams)
	Game.deploy_instance(new_explosion, global_position)
	
	if has_node("particles"):
		var particles: CPUParticles2D = %particles
		var pos: Vector2 = %particles.global_position
		remove_child(particles)
		Game.deploy_instance(particles, pos)
		var timer: Timer = Timer.new()
		particles.emitting = false
		particles.add_child(timer)
		timer.start(particles.lifetime)
		timer.timeout.connect(particles.queue_free)
	
	queue_free()


func _on_timer_timeout() -> void:
	armed = true

func _on_enemy_detector_body_entered(body: Node2D) -> void:
	if armed and body is Enemy:
		explode.call_deferred()
