class_name IntConsoleType
extends BaseRegexCheckedConsoleType


func _init():
	super('Int', '^[+-]?\\d+$')


func normalize(value) -> int:
	return value
#	return int(self._reextract(value))
