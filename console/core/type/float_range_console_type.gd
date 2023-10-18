class_name FloatRangeConsoleType
extends BaseRangeConsoleType


func _init(minValue : float = 0.0, maxValue : float = 100.0, step : float = 0.1):
	super('FloatRange', minValue, maxValue, step)


# Normalize variable.
func normalize(value):
	value = float(self._reextract(value).replace(',', '.'))
	value = clamp(value, self.get_min_value(), self.get_max_value())

	if self._step != 0 and value != self.get_min_value():
		var prevVal = self.get_min_value()
		var curVal = self.get_min_value()

		while curVal < value:
			prevVal = curVal
			curVal += self._step

		if curVal - value < value - prevVal and curVal <= self.get_max_value():
			value = curVal
		else:
			value = prevVal

	return value
