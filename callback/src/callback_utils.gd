class_name CallbackUtils
extends RefCounted

enum Type \
{
	UNKNOWN,
	VARIABLE,
	METHOD
}


static func get_type(target, name : String) -> int:
	# Is it a METHOD
	if target.has_method(name):
		return Type.METHOD

	# Is it a VARIABLE
	if name in target:
		return Type.VARIABLE

	return Type.UNKNOWN


static func is_funcref(obj) -> bool:
	return "function" in obj \
		and obj.has_method("set_function") \
		and obj.has_method("get_function") \
		and obj.has_method("call_func") \
		and obj.has_method("call_funcv") \
		and obj.has_method("is_valid") \
		and obj.has_method("set_instance")
