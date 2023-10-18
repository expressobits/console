class_name FilterConsoleType
extends BaseConsoleType


enum Mode \
{
	ALLOW,
	DENY
}


var _filterList : Array
var _mode : Mode


func _init(filterList : Array, mode : Mode = Mode.ALLOW):
	super('Filter')
	self._filterList = filterList
	self._mode = mode


func check(value) -> Check:
	if (self._mode == Mode.ALLOW and self._filterList.has(value)) or \
		(self._mode == Mode.DENY and !self._filterList.has(value)):
		return Check.OK

	return Check.CANCELED
