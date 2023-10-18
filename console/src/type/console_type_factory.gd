class_name ConsoleTypeFactory


const TYPE_LIST = [
	preload('console_variant.gd'),
	preload('bool_console_type.gd'),
	preload('int_console_type.gd'),
	preload('float_console_type.gd'),
	preload('string_console_type.gd'),
	preload('vector2_console_type.gd'),
	null,  # Rect2
	preload('vector3_console_type.gd'),
]


# @param    int  type
# @returns  Result<Resource, Error>
static func _type_const_to_type_list_index(type):
	if type >= 0 and type < TYPE_LIST.size() and TYPE_LIST[type] != null:
		return ConsoleResult.new(TYPE_LIST[type])
	else:
		return ConsoleResult.new(null, \
			'Type `%s` is not supported by console, please rerer to the documentation to obtain full list of supported engine types.' % int(type))


# @param    int  engine_type
# @returns  Result<BaseType, Error>
static func create(engine_type):
	if typeof(engine_type) != TYPE_INT:
		return ConsoleResult.new(null, "First argument (engine_type) must be of type int, `%s` type provided." % typeof(engine_type))

	var engine_type_result = _type_const_to_type_list_index(engine_type)

	if engine_type_result.has_error():
		return engine_type_result

	return ConsoleResult.new(engine_type_result.get_value().new())
