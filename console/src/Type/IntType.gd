class_name IntConsoleType
extends BaseRegexCheckedConsoleType


func _init():
	super('Int', '^[+-]?\\d+$')


# @param    Variant  value
# @returns  int
func normalize(value):
	return value
#	return int(self._reextract(value))
