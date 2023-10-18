class_name FuncRefCallback
extends AbstractCallback


# @param  FuncRef  target
func _init(target):
	super(target, CallbackUtils.Type.METHOD)


# Ensure callback target exists
# @returns  bool
func ensure():
	return self._target.is_valid()


# @param    Variant[]  argv
# @returns  Variant
func call(argv = []):
	# Ensure callback target still exists
	if !ensure():
		print(errors["qc.callback.call.ensure_failed"] % [ self._target ])
		return

	# Execute call
	return self._target.call_funcv(self._get_args(argv))
