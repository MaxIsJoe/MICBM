class_name ModifierResult
extends RefCounted


var value: float = 0


func combine_with(what: ModifierResult) -> ModifierResult:
	var output: ModifierResult = ModifierResult.new()
	output.value = value + what.value
	return output
