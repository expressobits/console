class_name BaseCommands
extends Node

func _ready():
	Console.add_command('echo', Console, 'write')\
		.set_description('Prints a string.')\
		.add_argument('text', TYPE_STRING)\
		.register()

	Console.add_command('commands', self, '_list_commands')\
		.set_description('Lists all available commands.')\
		.register()

	Console.add_command('help', self, '_help')\
		.set_description('Outputs usage instructions.')\
		.add_argument('command', TYPE_STRING)\
		.register()

	Console.add_command('quit', self, '_quit')\
		.set_description('Exit application.')\
		.register()

	Console.add_command('clear', Console)\
		.set_description('Clear the terminal.')\
		.register()

	Console.add_command('version', self, '_version')\
		.set_description('Shows engine version.')\
		.register()


# Display help message or display description for the command.
func _help(command_name = null):
	if command_name:
		var command = Console.get_command(command_name)

		if command:
			command.describe()
		else:
			Console.log.warn('No help for `' + command_name + '` command were found.')

	else:
		Console.write_line(\
			"Type [color=#ffff66][url=help]help[/url] <command-name>[/color] show information about command.\n" + \
			"Type [color=#ffff66][url=commands]commands[/url][/color] to get a list of all commands.\n" + \
			"Type [color=#ffff66][url=quit]quit[/url][/color] to exit the application.")


# Prints out engine version.
func _version():
	Console.write_line(str(Engine.get_version_info()))


func _list_commands():
	Console.write_line('[color=#ff66ff]=== ALL COMMANDS ===[/color]')
	for command in Console._command_service.values():
		var name = command.get_name()
		Console.write_line('[color=#ffff66][url=%s]%s[/url][/color]' % [ name, name ])


# Quitting application.
func _quit():
	Console.log.warn('Quitting application...')
	Console.get_tree().quit()
