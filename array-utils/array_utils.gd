extends RefCounted
class_name ArrayUtils

static func to_array(value) -> Array:
	if is_array(value):
		return value

	elif typeof(value) != TYPE_NIL:
		return [ value ]

	return []


static func is_array(value) -> bool:
	return typeof(value) >= TYPE_ARRAY


static func to_dict(value) -> Dictionary:
	if typeof(value) == TYPE_DICTIONARY:
		return value

	var d = {}

	if typeof(value) != TYPE_NIL:
		if is_array(value):
			for i in value.size():
				d[i] = value[i]
		else:
			d[0] = value

	return d


static func flatten(in_array : Array, out_array : Array = [], depth : int = -1) -> Array:
	assert(typeof(in_array) == TYPE_ARRAY, "qc/array-utils: Utils: in_array must be an array")

	for i in in_array.size():
		if is_array(in_array[i]) and depth > 0:
			flatten(in_array[i], out_array, depth - 1)
		else:
			out_array.append(in_array[i])

	return out_array
