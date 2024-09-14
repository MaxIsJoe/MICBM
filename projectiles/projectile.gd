@icon("res://projectiles/projectile.png")
class_name Projectile
extends Hitbox


@export var death_scene: PackedScene = null
@export var duration: float = 10.0
@export var penetrations: int = 0

var velocity: Vector2 = Vector2()
var acceleration: Vector2 = Vector2()
var thru_walls: bool = false


func _ready() -> void:
	super()
	
	z_index = 1

func _process(delta: float) -> void:
	#super(delta)
	
	velocity += acceleration * delta
	position += velocity * delta
	
	duration -= delta
	if duration <= 0:
		die()


func hit_being(what):
	super(what)
	
	penetrations -= 1
	if penetrations < 0:
		die()

func die():
	if death_scene:
		var new_scene = death_scene.instantiate()
		Game.deploy_instance(new_scene, global_position)
		
	queue_free()
