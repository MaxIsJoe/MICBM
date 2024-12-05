class_name ModifierType
extends Resource

enum ModifierUse {
	Benefit = -1,
	Neutral = 0,
	Restrain = 1
}

@export var name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture2D = null
@export var effect: GDScript = null
@export var modUse: ModifierUse = ModifierUse.Neutral
@export var activation_audio: AudioStream

func instantiate() -> Modifier:
	var output = effect.new()
	output.type = self
	return output
