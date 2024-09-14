class_name ModifierContext
extends RefCounted


enum ctx {
	# Stat calculations
	FRICTION,
	ACCELERATION,
	BLAST_RADIUS,
	CAMERA_ZOOM,
	REMOVAL_SPEED,
	BUILD_POWER,
	BUILD_SPEED,
	# Specific events
	ENEMY_SLAIN,
	ENEMY_HIT,
	MODIFIERS_CHANGED,
}

var context: ctx
var father: Entity = null
var modifier_list: ModifierList = null
