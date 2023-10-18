class_name BaseConsoleType

enum Check \
{
	OK,
	FAILED,
	CANCELED
}

var _name : String


func _init(name : String):
	self._name = name


# Assignment check.
# Returns one of the statuses:
# CHECK.OK, CHECK.FAILED and CHECK.CANCELED
func check(value) -> Check:
	return Check.OK


# Normalize variable
func normalize(value):
	return value


func to_string() -> String:
	return self._name
