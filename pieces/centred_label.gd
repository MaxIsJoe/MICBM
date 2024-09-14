@tool
@icon("res://pieces/centred_label.png")
class_name CentredLabel
extends RichTextLabel


@export var centred := true
@export_multiline var base_text := "": set = set_base_text

var prev_text := ""


func _ready() -> void:
	bbcode_enabled = true
	fit_content = true

func _process(_delta: float) -> void:
	if centred:
		if prev_text != text:
			centre_text()
			prev_text = text


func set_base_text(what: String):
	base_text =  what
	text = tr(base_text)
	if centred:
		centre_text()

func centre_text():
	if !text.begins_with("[center]"):
		text = "[center]%s[/center]" % text
