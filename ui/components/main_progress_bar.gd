extends TextureProgressBar


@export var texts: Array[String] = [
	"Preparing silo",
	"Welding sheets",
	"Throwing wrenches",
	"Imagining dreams",
	"Selecting restraints",
	"Activating knobs",
	"Inserting fuel",
	"Activating missile",
]


func _ready() -> void:
	Events.progress_changed.connect(_on_progress_changed)


func _on_progress_changed():
	max_value = Game.get_run().max_progress
	value = Game.get_run().progress
	
	var index: int = int(ratio * texts.size())
	index = clamp(index, 0, texts.size()-1)
	var percentage: float = floor(ratio*100)
	%label.base_text = "%s... %s%%" % [texts[index], percentage]
