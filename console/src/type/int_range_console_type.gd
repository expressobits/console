class_name IntRangeConsoleType
extends BaseRangeConsoleType


func _init(minValue : int = 0, maxValue : int = 100, step : int = 1):
	super('IntRange', minValue, maxValue, step)


func normalize(value):
	value = float(self._reextract(value).replace(',', '.'))
	value = clamp(value, self.get_min_value(), self.get_max_value())

	# Find closest step
	if self._step != 1 and value != self.get_min_value():
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
