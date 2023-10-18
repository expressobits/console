class_name ConsoleCommand
extends RefCounted

enum ArgType { NORMAL = 0, STRING = 1}
var _name : String
var _target
var _arguments : Array
var _description

var _arg_type : ArgType = ArgType.NORMAL

func _init(name : String, target, arguments : Array = [], description = null, arg_type : ArgType = ArgType.NORMAL):
	self._name = name
	self._target = target
	self._arguments = arguments
	self._description = description
	self._arg_type = arg_type


func get_name() -> String:
	return self._name


func get_target():
	return self._target


func get_arguments() -> Array:
	return self._arguments


func get_description():
	return self._description


func execute(in_args : Array = []):
	var args = []
	var arg_assig

	var i = 0

	while i < self._arguments.size() and i < in_args.size():

		arg_assig = self._arguments[i].set_value(in_args[i])

		if arg_assig == FAILED:
			Console.log.warn(\
				'Expected %s %s as argument.' % [self._arguments[i].get_type().to_string(), str(i + 1)])
			return
		elif arg_assig == ConsoleArgument.Assignment.CANCELED:
			return OK

		args.append(self._arguments[i].get_normalized_value())
		i += 1

	# Execute command
	if self._target != null:
		return self._target.call(args)
	return null


func describe():
	Console.write_line('NAME')
	Console.write_line(self._get_command_name())
	Console.write_line()

	Console.write_line('USAGE')
	Console.write(self._get_command_name())

	if self._arguments.size() > 0:
		for arg in self._arguments:
			Console.write(' [color=#88ffff]%s[/color]' %  arg.describe())

	Console.write_line()
	Console.write_line()

	if self._description:
		Console.write_line('DESCRIPTION')
		Console.write_line('	' + self._description)

	Console.write_line()


func _get_command_name() -> String:
	return '	[color=#ffff66][url=%s]%s[/url][/color]' % [self._name, self._name]
