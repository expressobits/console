class_name CallbackBuilder
extends RefCounted

const errors = preload("../assets/translations/errors.en.gd").messages

var _target
var _name : String
var _type : int
var _bind_argv : Array


func _init(target):
	self._target = target
	self._type = CallbackUtils.Type.UNKNOWN
	self._bind_argv = []


func set_name(name : String) -> CallbackBuilder:
	self._name = name
	return self


func get_name() -> String:
	return self._name


func set_variable(name : String) -> CallbackBuilder:
	self._name = name
	self._type = CallbackUtils.Type.VARIABLE
	return self


func set_method(name : String) -> CallbackBuilder:
	self._name = name
	self._type = CallbackUtils.Type.METHOD
	return self


func set_type(type : CallbackUtils.Type) -> CallbackBuilder:
	self._type = type
	return self


func get_type() -> CallbackUtils.Type:
	return self._type


func bind(argv : Array = []) -> CallbackBuilder:
	self._bind_argv = argv
	return self


func build() -> AbstractCallback:
	if typeof(self._target) != TYPE_OBJECT:
		print(errors["qc.callback.canCreate.first_arg"] % str(typeof(self._target)))
		return null

	if CallbackUtils.is_funcref(self._target):
		return FuncRefCallback.new(self._target)

	if typeof(self._name) != TYPE_STRING:
		print(errors["qc.callback.canCreate.second_arg"] % str(typeof(self._name)))
		return null

	if not self._type or self._type == CallbackUtils.Type.UNKNOWN:
		self._type = CallbackUtils.get_type(self._target, self._name)
		if self._type == CallbackUtils.Type.UNKNOWN:
			print(errors["qc.callback.target_missing_mv"] % [ self._target, self._name ])
			return null

	var callback = ConsoleCallback.new(self._target, self._name, self._type)
	callback.bind(self._bind_argv)
	return callback
