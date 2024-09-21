extends CharacterBody2D

@export var max_speed: float = 200.0
@export var acceleration: float = 2000.0


func _physics_process(_delta: float) -> void:
	frictutate(_delta)
	move_and_slide()

func accelerate(dir: Vector2, delta: float):
	velocity += dir * acceleration * delta


func frictutate(delta: float):
	if max_speed > 0:
		var friction: float = acceleration / max_speed
		var velocity_decrease: float = friction * delta
		velocity_decrease = min(velocity_decrease, 1)
		velocity -= velocity * velocity_decrease
	else:
		velocity = Vector2()
