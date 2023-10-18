class_name BoolConsoleType
extends BaseConsoleType


func _init():
	super('Bool')


# @param    Variant  value
# @returns  Variant
func normalize(value):
	return value == '1' or value == 'true'
