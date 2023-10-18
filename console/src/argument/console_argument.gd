class_name ConsoleArgument
extends RefCounted


enum Assignment \
{
	OK,
	FAILED,
	CANCELED
}


var _name : String
var _type : BaseConsoleType
var _description
var _original_value : String
var _normalized_value


func _init(name : String, type : BaseConsoleType, description = null):
	self._name = name
	self._type = type
	self._description = description


# @returns  String
func get_name() -> String:
	return self._name


func get_type() -> BaseConsoleType:
	return self._type


func get_value() -> String:
	return self._original_value


func set_value(value) -> int:
	self._original_value = value

	var check = self._type.check(value)
	if check == OK:
		self._normalized_value = self._type.normalize(value)

	return check


func get_normalized_value():
	return self._normalized_value


func describe() -> String:
	return '<%s:%s>' % [self._name, self._type.to_string()]
