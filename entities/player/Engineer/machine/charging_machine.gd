extends State

@export var charged_state: State
@onready var charge_progress: ProgressBar = $"../../charge-progress"
@onready var charge_timer: Timer = $"../../charge-progress/timer"


func _enter():
	super()
	charge_timer.start()

func _on_timer_timeout() -> void:
	charge_progress.value += 1
	if charge_progress.value >= 100:
		charge_timer.stop()
		set_state("attacking")
