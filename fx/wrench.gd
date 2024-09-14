extends Node2D


@export var break_scene: PackedScene = null
@export var power: float = 1

var rotation_speed: float = randf() * PI*2


func _ready() -> void:
	approach_nearest_silo.call_deferred()
	%sprite.rotation = randf() * PI*2

func _process(delta: float) -> void:
	%sprite.rotation += rotation_speed * delta


func approach_nearest_silo():
	var nearest_silo: Node2D = Util.get_nearest_group_member("silos", global_position)
	if is_instance_valid(nearest_silo):
		var relative: Vector2 = global_position - nearest_silo.global_position
		var offset: float = randf_range(192, 320)
		var target_position: Vector2 = nearest_silo.global_position + relative.normalized() * offset
		git_going(target_position)

func git_going(where: Vector2, duration: float = 1):
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "global_position", where, duration)
	tween.tween_callback(arrive)

func arrive():
	Game.get_run().progress += power
	
	if break_scene:
		var new_break = break_scene.instantiate()
		Game.deploy_instance(new_break, global_position)
	
	queue_free()
