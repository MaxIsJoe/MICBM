extends Node

var gameholder: Control = null
var world: Node2D = null
var ui: Control = null
var player: Player = null
var camera: Camera2D = null
var run: Run = null
var objects: Dictionary = {
	"wrench": preload("res://fx/wrench.tscn"),
	"coin": preload("res://props/coin.tscn"),
	"upgrade": preload("res://props/upgrade.tscn"),
	"crown": preload("res://fx/crown.tscn"),
	"corpse": preload("res://props/corpse.tscn"),
	"bomb": preload("res://props/bomb.tscn"),
	"srbm": preload("res://props/srbm.tscn"),
	"explosion": preload("res://fx/explosion.tscn"),
	
	"upgrade_screen": preload("res://ui/upgrade_screen.tscn"),
}

var next_player_to_spawn: PackedScene = null

const pause_menu_scene: PackedScene = preload("res://ui/pause_menu.tscn")

var start_time: float


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if !get_tree().paused and event.is_action_pressed("ui_cancel"):
		var new_menu = pause_menu_scene.instantiate()
		deploy_ui_instance(new_menu, Vector2())
		update_pause_status()


func is_in_run() -> bool:
	return run != null

func get_run() -> Run:
	if run: return run
	run = Run.new()
	return run

func start_run():
	run = Run.new()
	start_time = Time.get_ticks_msec()

func get_time_passed() -> float:
	return (Time.get_ticks_msec() - start_time) / 1000.0

func update_pause_status():
	get_tree().paused = get_tree().get_nodes_in_group("pausers").size() > 0

func get_object(what: String):
	return objects[what]

func deploy_instance(what: CanvasItem, where: Vector2):
	if is_instance_valid(world):
		world.call_deferred("add_child", what)
		what.position = where
	else:
		push_warning("Attempted to deploy %s, but there is no world" % what)

func deploy_ui_instance(what: CanvasItem, where: Vector2):
	if is_instance_valid(ui):
		ui.add_child(what)
		what.position = where
	else:
		push_warning("Attempted to deploy %s into the UI, but there is no ui" % what)

func activate_all_modifiers(context: ModifierContext) -> ModifierResult:
	var output: ModifierResult = ModifierResult.new()
	
	for i in get_tree().get_nodes_in_group("modifiers"):
		if (i == null): continue
		if (i.is_queued_for_deletion()): continue
		if !i.disabled:
			var this_result: ModifierResult = i.activate(context)
			output = output.combine_with(this_result)
	
	return output

func shake_cam(amount: float, direction: float = randf() * PI * 2):
	if is_instance_valid(camera):
		camera.position += Vector2(amount, 0).rotated(direction)
