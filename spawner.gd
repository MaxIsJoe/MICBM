extends Node


@export var enemies: ResourceGroup = null
@export var max_ubers: int = 2

var value_gain: float = 0.5
var value: float = 5
var offscreen_margin: float = 48
var timer: Timer = Timer.new()


func _ready() -> void:
	add_child(timer)
	
	timer.start(11)
	timer.timeout.connect(spawn_wave)
	spawn_wave.call_deferred()

func _process(delta: float) -> void:
	value += value_gain * delta


func count_ubers() -> int:
	var output: int = 0
	
	for i in get_tree().get_nodes_in_group("enemies"):
		if i.uber: output += 1
	
	return output

func spawn_wave():
	var available_enemies: Array[EnemyType] = []
	
	var min_cost: float = 1000000
	var total_weight: float = 0
	for this_enemy in enemies.load_all():
		if this_enemy is EnemyType:
			if this_enemy.cost > value: continue
			
			min_cost = min(this_enemy.cost, min_cost)
			total_weight += this_enemy.weight
			
			available_enemies.append(this_enemy)
	
	while value > min_cost:
		var roll = randf() * total_weight
		for this_enemy in available_enemies:
			roll -= this_enemy.weight
			if roll <= 0:
				if this_enemy.cost > value: continue
				
				spawn_enemy(this_enemy)
				value -= this_enemy.cost
				break

func spawn_enemy(what: EnemyType):
	if is_instance_valid(Game.player):
		var dir: float = randf() * PI*2
		var visible_size: Vector2 = get_viewport().get_visible_rect().size
		if is_instance_valid(Game.camera):
			visible_size /= Game.camera.zoom
		var diagonal = visible_size.length()/2 + offscreen_margin
		var pos: Vector2 = Game.player.global_position + Vector2(diagonal, 0).rotated(dir)
		
		var new_enemy: Node2D = what.scene.instantiate()
		if randf() < 0.25 and count_ubers() < max_ubers:
			new_enemy.uber = true
		Game.deploy_instance(new_enemy, pos)
