class_name CommandBuilder
extends RefCounted


var _console
var _command_service
var _name : String
var _target
var _arguments : Array
var _description

var _arg_type : ConsoleCommand.ArgType = ConsoleCommand.ArgType.NORMAL


func _init(console, command_service, name : String, target, target_name = null):
	self._console = console
	self._command_service = command_service

	self._name = name
	self._target = self._initialize_target_callback(target, target_name)
	self._arguments = []
	self._description = null


func _initialize_target_callback(target, name = null):
	if target is ConsoleCallback:
		return target

	name = name if name else self._name

	var callback = CallbackBuilder.new(target).set_name(name).build()

	if not callback:
		self._console.log.error(\
			'CommandBuilder: Failed to create [b]`%s`[/b] command. Failed to create callback to target with method [b]`%s`[/b].' %
			[ self._name, name ])

	return callback


func add_argument(name : String, type = null, description = null) -> CommandBuilder:
	# @var  Result<Argument, Error>
	var argument_result = ArgumentFactory.create(name, type, description)
	var error = argument_result.get_error()
	if error:
		if error.get_code() != ArgumentFactory.FALLBACK_ERROR:
			self._console.log.error(error.get_message())
			return self
		else:
			self._console.log.warn(\
				"CommandBuilder: add_argument for command `%s` for argument `%s` failed with: %s" % [self._name, name, error.get_message()])

	var argument = argument_result.get_value()
	self._arguments.append(argument)
	return self


func set_description(description = null) -> CommandBuilder:
	self._description = description
	return self


func set_arg_type(arg_type : ConsoleCommand.ArgType):
	self._arg_type = arg_type
	return self


func register():
	var command = ConsoleCommand.new(self._name, self._target, self._arguments, self._description, self._arg_type)
	if not self._command_service.set(self._name, command):
		self._console.log.error("CommandBuilder::register: Failed to create [b]`%s`[/b] command. Command already exists." % self._name)
