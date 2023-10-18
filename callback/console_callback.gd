class_name ConsoleCallback
extends AbstractCallback

var _name : String


func _init(target, name : String, type : CallbackUtils.Type = CallbackUtils.Type.UNKNOWN):
	super(target, type if type != CallbackUtils.Type.UNKNOWN else CallbackUtils.get_type(target, name))
	self._name = name


func get_name() -> String:
	return self._name


# Ensure callback target exists
func ensure() -> bool:
	if self._target:
		var wr = weakref(self._target)
		if wr.get_ref() == null:
			print(errors["qc.callback.ensure.target_destroyed"] % self._name)
			return false
	else:
		print(errors["qc.callback.ensure.target_destroyed"] % self._name)
		return false

	if CallbackUtils.get_type(self._target, self._name) == CallbackUtils.Type.UNKNOWN:
		print(errors["qc.callback.target_missing_mv"] % [ self._target, self._name ])
		return false

	return true


func call(argv : Array = []):
	# Ensure callback target still exists
	if !ensure():
		print(errors["qc.callback.call.ensure_failed"] % [ self._target, self._name ])
		return

	argv = self._get_args(argv)

	# Execute call
	if self._type == CallbackUtils.Type.VARIABLE:
		if argv.size():
			self._target.set(self._name, argv[0])

		return self._target.get(self._name)

	elif self._type == CallbackUtils.Type.METHOD:
		return self._target.callv(self._name, argv)

	print(errors["qc.callback.call.unknown_type"] % [ self._target, self._name ])
