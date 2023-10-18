class_name BoolConsoleType
extends BaseConsoleType


func _init():
	super('Bool')


func normalize(value):
	return value == '1' or value == 'true'
