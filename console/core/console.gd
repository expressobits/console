extends Node

## Signals

signal toggled(is_console_shown : bool)
signal command_added(name : String, target, target_name)
signal command_removed(name : String)
signal command_executed(command : ConsoleCommand)
signal command_not_found(name : String)
signal write_message(message : String)
signal clear_message
signal raw_input(raw_input : String)

@export var history : ConsoleHistory
@export var log : Logger

var _command_service
var _erase_bb_tags_regex : RegEx
var is_console_shown : bool = true
@export var consume_input : bool = true
@export var use_prefix_for_commands : bool = true
@export var default_command : String
@export var print_command_in_console : bool = false


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
	BaseCommands.new(self)


func _input(e : InputEvent):
	if not e is InputEventKey:
		return
	if e.is_action_pressed(ConsoleDefaultActions.CONSOLE_TOGGLE):
		self.toggle_console()
		
	if is_console_shown and e.is_action_pressed(ConsoleDefaultActions.CLOSE_CONSOLE):
		self.toggle_console()
	if not is_console_shown and e.is_action_pressed(ConsoleDefaultActions.OPEN_CONSOLE):
		self.toggle_console()


func get_command_service():
	return self._command_service


func get_command(name : String):
	return self._command_service.get(name)


func find_commands(name : String):
	return self._command_service.find(name)

# Example usage:
# ```gdscript
# Console.add_command('sayHello', self, 'print_hello')\
# 	.set_description('Prints "Hello %name%!"')\
# 	.add_argument('name', TYPE_STRING)\
# 	.register()
# ```
func add_command(name : String, target, target_name = null):
	emit_signal("command_added", name, target, target_name)
	return self._command_service.create(name, target, target_name)


func remove_command(name : String):
	emit_signal("command_removed", name)
	return self._command_service.remove(name)


func write(message : String):
	message = str(message)
	emit_signal("write_message", message)
	# print(self._erase_bb_tags_regex.sub(message, '', true))


func write_line(message : String = ''):
	message = str(message)
	emit_signal("write_message", message + '\n')
	# print(self._erase_bb_tags_regex.sub(message, '', true))


func clear():
	emit_signal("clear_message")


func toggle_console():
	is_console_shown = !self.is_console_shown
	emit_signal("toggled", is_console_shown)
	return self


func _set_readonly(value):
	log.warn('qc/console: _set_readonly: Attempted to set a protected variable, ignoring.')
