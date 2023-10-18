class_name ArgumentFactory
extends RefCounted


const FALLBACK_ERROR = '73ca5439-fd62-442f-8a33-73135dbf5469'


# @param    String        name
# @param    int|BaseType  type
# @param    String|null   description
# @returns  Result
static func create(name, type = 0, description = null):
	var error_message

	# Define argument type
	if typeof(type) == TYPE_INT:
		var type_result = ConsoleTypeFactory.create(type)

		if type_result.has_error():
			error_message = "%s Falling back to `Any` type." % type_result.get_error().get_message()
			type = ConsoleTypeFactory.create(0).get_value()
		else:
			type = type_result.get_value()

	if not type is BaseConsoleType:
		return ConsoleResult.new(null, "Second argument (type) must extend BaseType. If you want to use custom types please refer to the documentation for more info.")

	var error
	if error_message:
		error = ConsoleError.new(error_message, FALLBACK_ERROR)

	return ConsoleResult.new(ConsoleArgument.new(name, type, description), error)
