extends Control


@export var rotation_size: float = .2
@export var animation_duration: float = .5

var current_tween: Tween = null


func _ready() -> void:
	Events.money_changed.connect(_on_money_changed)


func _on_money_changed():
	%label.base_text = "€%04d" % Game.get_run().money
	
	if current_tween:
		if current_tween.is_running():
			current_tween.stop()
		current_tween = null
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	
	%image.rotation += rotation_size if randf() < 0.5 else -rotation_size
	tween.tween_property(%image, "rotation", 0, animation_duration)
	scale = Vector2(1, 1)
	tween.parallel().tween_property(self, "scale", Vector2(.8, .8), animation_duration)
	modulate = Color(4, 4, 4, 1)
	tween.parallel().tween_property(self, "modulate", Color(1, 1, 1, 1), animation_duration)
	
	current_tween = tween
