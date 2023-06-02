
extends CanvasLayer

const BaseCommands = preload('Misc/BaseCommands.gd')
const DefaultActions = preload('../DefaultActions.gd')
const CommandService = preload('Command/CommandService.gd')

### Custom console types
const IntRangeType = preload('Type/IntRangeType.gd')
const FloatRangeType = preload('Type/FloatRangeType.gd')
const FilterType = preload('Type/FilterType.gd')

## Signals

# @param  bool  is_console_shown
signal toggled(is_console_shown)
# @param  String       name
# @param  RefCounted    target
# @param  String|null  target_name
signal command_added(name, target, target_name)
# @param  String  name
signal command_removed(name)
# @param  Command  command
signal command_executed(command)
# @param  String  name
signal command_not_found(name)

signal write_message(message)

signal clear_message

# @var  History
var History = preload('Misc/History.gd').new(100):
	set(value): 
		_set_readonly(value)

# @var  Logger
var Log = preload('Misc/Logger.gd').new():
	set(value): 
		_set_readonly(value)

# @var  Command/CommandService
var _command_service

# Used to clear text from bb tags
# @var  RegEx
var _erase_bb_tags_regex

# @var  bool
var is_console_shown = true

# @var  bool
var consume_input = true

var use_prefix_for_commands := true

var default_command : String

func _init():
	self._command_service = CommandService.new(self)
	# Used to clear text from bb tags before printing to engine output
	self._erase_bb_tags_regex = RegEx.new()
	self._erase_bb_tags_regex.compile('\\[[\\/]?[a-z0-9\\=\\#\\ \\_\\-\\,\\.\\;]+\\]')


func _ready():
	self.toggle_console()

	# Console keyboard control
	set_process_input(true)

	# Show some info
	var v = Engine.get_version_info()
	self.write_line(\
		ProjectSettings.get_setting("application/config/name") + \
		" (Godot " + str(v.major) + '.' + str(v.minor) + '.' + str(v.patch) + ' ' + v.status+")\n" + \
		"Type [color=#ffff66][url=help]help[/url][/color] to get more information about usage")

	# Init base commands
	self.BaseCommands.new(self)


# @param  InputEvent  e
func _input(e):
	if not e is InputEventKey:
		return
	if e.is_action_pressed(DefaultActions.CONSOLE_TOGGLE):
		self.toggle_console()
	if is_console_shown and e.is_action_pressed(DefaultActions.CLOSE_CONSOLE):
		self.toggle_console()
	if not is_console_shown and e.is_action_pressed(DefaultActions.OPEN_CONSOLE):
		self.toggle_console()


# @returns  Command/CommandService
func get_command_service():
	return self._command_service


# @param    String  name
# @returns  Command/Command|null
func get_command(name):
	return self._command_service.get(name)

# @param    String  name
# @returns  Command/CommandCollection
func find_commands(name):
	return self._command_service.find(name)

# Example usage:
# ```gdscript
# Console.add_command('sayHello', self, 'print_hello')\
# 	.set_description('Prints "Hello %name%!"')\
# 	.add_argument('name', TYPE_STRING)\
# 	.register()
# ```
# @param    String       name
# @param    RefCounted    target
# @param    String|null  target_name
# @returns  Command/CommandBuilder
func add_command(name, target, target_name = null):
	emit_signal("command_added", name, target, target_name)
	return self._command_service.create(name, target, target_name)

# @param    String  name
# @returns  int
func remove_command(name):
	emit_signal("command_removed", name)
	return self._command_service.remove(name)


# @param    String  message
# @returns  void
func write(message):
	message = str(message)
	emit_signal("write_message", message)
	print(self._erase_bb_tags_regex.sub(message, '', true))

# @param    String  message
# @returns  void
func write_line(message = ''):
	message = str(message)
	emit_signal("write_message", message + '\n')
	print(self._erase_bb_tags_regex.sub(message, '', true))


# @returns  void
func clear():
	emit_signal("clear_message")


# @returns  Console
func toggle_console():
	is_console_shown = !self.is_console_shown
	emit_signal("toggled", is_console_shown)
	return self


# @returns  void
func _set_readonly(value):
	Log.warn('qc/console: _set_readonly: Attempted to set a protected variable, ignoring.')
