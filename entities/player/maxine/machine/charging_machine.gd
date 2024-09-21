extends State

@export var charged_state: State
@export var charge_per_second: float = 1
@onready var charge_progress: ProgressBar = $"../../charge-progress"
@onready var charge_timer: Timer = $"../../charge-progress/timer"


func _enter():
	super()
	charge_timer.start()

func _on_timer_timeout() -> void:
	charge_progress.value += charge_per_second
	if charge_progress.value >= 100:
		charge_timer.stop()
		set_state(charged_state.name)
