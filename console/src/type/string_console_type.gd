class_name StringConsoleType
extends BaseConsoleType


func _init():
	super('String')


# Normalize variable
# @param    Varian  value
# @returns  String
func normalize(value):
	return str(value)
