class_name Run
extends RefCounted

var money: float = 0: set = set_money
var max_progress: float = 400
var progress: float = 0: set = set_progress

var GAMTESTAT_KEY_ENEMIES_BOUND: String = "Enemies Bound"
var GAMTESTAT_KEY_RESTRAINTS_FREED: String = "Times Player Freed Themselves"
var GAMTESTAT_KEY_TOTAL_MONEY_COLLECTED: String = "Total Money Collected"
var GAMTESTAT_KEY_TIMES_PLAYER_HURT: String = "Times Player Was Bound"
var GAMTESTAT_KEY_TIMES_FRIENDLY_FIRE_HAPPENED: String = "Times Friendly Fire Happened"
var GAMTESTAT_KEY_STRONGEST_EXPLOSION_RECORDED: String = "Strongest Explosion Recorded"
var GAMTESTAT_KEY_TIME_SURVIVED: String = "Time Survived"
var GAMTESTAT_KEY_LAST_ATTACKER: String = "Last Attacker"

var game_stats: Dictionary = {
	GAMTESTAT_KEY_ENEMIES_BOUND: 0,
	GAMTESTAT_KEY_STRONGEST_EXPLOSION_RECORDED: 0,
	GAMTESTAT_KEY_TOTAL_MONEY_COLLECTED: 0,
	GAMTESTAT_KEY_TIME_SURVIVED: 0.0,
	GAMTESTAT_KEY_TIMES_FRIENDLY_FIRE_HAPPENED: 0,
	GAMTESTAT_KEY_TIMES_PLAYER_HURT: 0,
	GAMTESTAT_KEY_RESTRAINTS_FREED: 0,
	GAMTESTAT_KEY_LAST_ATTACKER: ""
}

var win_scene: PackedScene = preload("res://splashes/victory.tscn")


func set_money(what: float):
	money = what
	if (money > game_stats[GAMTESTAT_KEY_TOTAL_MONEY_COLLECTED]):
		game_stats[GAMTESTAT_KEY_TOTAL_MONEY_COLLECTED] = int(money)
	Events.money_changed.emit()

func set_progress(what: float):
	progress = what
	Events.progress_changed.emit()
	
	if progress >= max_progress:
		Game.get_tree().change_scene_to_packed(win_scene)

func set_attacker(last_attacker: Entity):
	game_stats[GAMTESTAT_KEY_LAST_ATTACKER] = last_attacker.name

func add_time_restraint_removed():
	game_stats[GAMTESTAT_KEY_RESTRAINTS_FREED] = game_stats[GAMTESTAT_KEY_RESTRAINTS_FREED] + 1

func add_time_player_hurt():
	game_stats[GAMTESTAT_KEY_TIMES_PLAYER_HURT] = game_stats[GAMTESTAT_KEY_TIMES_PLAYER_HURT] + 1