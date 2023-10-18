class_name StringConsoleType
extends BaseConsoleType


func _init():
	super('String')


func normalize(value) -> String:
	return str(value)
