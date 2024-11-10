class_name Run
extends RefCounted

var money: float = 0: set = set_money
var max_progress: float = 400
var progress: float = 0: set = set_progress

const GAMTESTAT_KEY_ENEMIES_BOUND: String = "Enemies Bound"
const GAMTESTAT_KEY_RESTRAINTS_FREED: String = "Times Player Freed Themselves"
const GAMTESTAT_KEY_TOTAL_MONEY_COLLECTED: String = "Total Money Collected"
const GAMTESTAT_KEY_TIMES_PLAYER_HURT: String = "Times Player Was Bound"
const GAMTESTAT_KEY_TIMES_FRIENDLY_FIRE_HAPPENED: String = "Times Friendly Fire Happened"
const GAMTESTAT_KEY_STRONGEST_EXPLOSION_RECORDED: String = "Strongest Explosion Recorded"
const GAMTESTAT_KEY_TIME_SURVIVED: String = "Time Survived"
const GAMTESTAT_KEY_LAST_ATTACKER: String = "Last Attacker"

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
	if progress > max_progress:
		game_stats[GAMTESTAT_KEY_TIME_SURVIVED] = Game.get_time_passed()
		Game.get_tree().change_scene_to_packed(win_scene)

func set_attacker(last_attacker: String):
	add_time_player_hurt()
	if last_attacker == Game.player.name:
		game_stats[GAMTESTAT_KEY_TIMES_FRIENDLY_FIRE_HAPPENED] = game_stats[GAMTESTAT_KEY_TIMES_FRIENDLY_FIRE_HAPPENED] + 1
		return
	game_stats[GAMTESTAT_KEY_LAST_ATTACKER] = last_attacker

func add_time_restraint_removed():
	game_stats[GAMTESTAT_KEY_RESTRAINTS_FREED] = game_stats[GAMTESTAT_KEY_RESTRAINTS_FREED] + 1

func add_time_player_hurt():
	game_stats[GAMTESTAT_KEY_TIMES_PLAYER_HURT] = game_stats[GAMTESTAT_KEY_TIMES_PLAYER_HURT] + 1

func record_explosion_strength(strength: float):
	if strength > game_stats[GAMTESTAT_KEY_STRONGEST_EXPLOSION_RECORDED]:
		game_stats[GAMTESTAT_KEY_STRONGEST_EXPLOSION_RECORDED] = strength

func enemy_restrained():
	game_stats[GAMTESTAT_KEY_ENEMIES_BOUND] = game_stats[GAMTESTAT_KEY_ENEMIES_BOUND] + 1
