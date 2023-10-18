class_name Vector2ConsoleType
extends BaseRegexCheckedConsoleType


var _normalized_value


func _init():
	super('Vector2', '^[+-]?([0-9]*[\\.\\,]?[0-9]+|[0-9]+[\\.\\,]?[0-9]*)([eE][+-]?[0-9]+)?$')


func check(value) -> Check:
	var values = str(value).split(',', false, 2)
	if values.size() < 2:
		if values.size() == 1:
			values.append('0')
		else:
			return Check.FAILED

	# Check each number
	for i in range(2):
		if super.check(values[i]) == Check.FAILED:
			return Check.FAILED

	# Save value
	self._normalized_value = Vector2(values[0].to_float(), values[1].to_float())

	return Check.OK


func normalize(value):
	return self._normalized_value
