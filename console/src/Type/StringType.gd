
extends 'res://addons/console/console/src/Type/BaseType.gd'


func _init():
	super('String')


# Normalize variable
# @param    Varian  value
# @returns  String
func normalize(value):
	return str(value)
