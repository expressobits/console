class_name FloatConsoleType
extends BaseRegexCheckedConsoleType


func _init():
	super('Float', '^[+-]?([0-9]*[\\.\\,]?[0-9]+|[0-9]+[\\.\\,]?[0-9]*)([eE][+-]?[0-9]+)?$')


func normalize(value) -> float:
	return float(self._reextract(value).replace(',', '.'))
