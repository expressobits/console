extends RefCounted
class_name AbstractCallback

const errors = preload("../assets/translations/errors.en.gd").messages

var _target
var _type : CallbackUtils.Type
var _bind_argv : Array


func _init(target, type : CallbackUtils.Type):
	self._target = target
	self._type = type
	self._bind_argv = []


func get_target():
	return self._target


func get_type() -> int:
	return self._type


func ensure() -> bool:
	return false


func bind(argv : Array = []):
	for _argv in argv:
		self._bind_argv.append(_argv)


func call(argv = []):
	pass


func _get_args(args : Array = []) -> Array:
	var new_args = self._bind_argv.duplicate()

	for arg in args:
		new_args.append(arg)

	return new_args
