extends Camera2D


@export var unshake_speed: float = 8
@export var zoom_speed: float = 1
@export var target_zoom: Vector2 = Vector2(0.5, 0.5)


func _ready() -> void:
	Game.camera = self

func _process(delta: float) -> void:
	zoom = zoom.lerp(target_zoom, zoom_speed*delta)
	position = position.lerp(Vector2(), unshake_speed*delta)
