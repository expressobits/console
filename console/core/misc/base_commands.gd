class_name BaseCommands
extends RefCounted


var _console

func _init(console):
	self._console = console

	self._console.add_command('echo', self._console, 'write')\
		.set_description('Prints a string.')\
		.add_argument('text', TYPE_STRING)\
		.register()

	self._console.add_command('commands', self, '_list_commands')\
		.set_description('Lists all available commands.')\
		.register()

	self._console.add_command('help', self, '_help')\
		.set_description('Outputs usage instructions.')\
		.add_argument('command', TYPE_STRING)\
		.register()

	self._console.add_command('quit', self, '_quit')\
		.set_description('Exit application.')\
		.register()

	self._console.add_command('clear', self._console)\
		.set_description('Clear the terminal.')\
		.register()

	self._console.add_command('version', self, '_version')\
		.set_description('Shows engine version.')\
		.register()


# Display help message or display description for the command.
func _help(command_name = null):
	if command_name:
		var command = self._console.get_command(command_name)

		if command:
			command.describe()
		else:
			self._console.log.warn('No help for `' + command_name + '` command were found.')

	else:
		self._console.write_line(\
			"Type [color=#ffff66][url=help]help[/url] <command-name>[/color] show information about command.\n" + \
			"Type [color=#ffff66][url=commands]commands[/url][/color] to get a list of all commands.\n" + \
			"Type [color=#ffff66][url=quit]quit[/url][/color] to exit the application.")


# Prints out engine version.
func _version():
	self._console.write_line(Engine.get_version_info())


func _list_commands():
	Console.write_line('[color=#ff66ff]=== ALL COMMANDS ===[/color]')
	for command in self._console._command_service.values():
		var name = command.get_name()
		self._console.write_line('[color=#ffff66][url=%s]%s[/url][/color]' % [ name, name ])


# Quitting application.
func _quit():
	self._console.log.warn('Quitting application...')
	self._console.get_tree().quit()
