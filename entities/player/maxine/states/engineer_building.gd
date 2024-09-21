extends State

@onready var build_ui: Control = $"../../BuildUI"

func _ready() -> void:
	super()
	build_ui.building_done.connect(machine_build)

func _enter():
	super()
	build_ui.show()
	build_ui.generate_new_inputs()

func machine_build(machine: PackedScene):
	var new_machine = machine.instantiate()
	Game.deploy_instance(new_machine, father.global_position)
	build_ui.hide()
	set_state("normal")
