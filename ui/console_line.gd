class_name ConsoleLine
extends LineEdit

const COMMANDS_SEPARATOR = ';'
const RECOMMANDS_SEPARATOR = '(?<!\\\\)' + COMMANDS_SEPARATOR
const COMMAND_PARTS_SEPARATOR = ' '
const QUOTES = [ '"', "'" ]
const SCREENERS = [ '\\/' ]
const COMMAND_PREFIX = '/'

var _tmp_user_entered_command
var _current_command
var _autocomplete_triggered_timer : SceneTreeTimer


func _ready():
	# Console keyboard control
	self.set_process_input(true)
	self.caret_blink = true
	self.connect("text_submitted", execute)


func _gui_input(event : InputEvent):
	pass
	#if Console.consume_input and self.has_focus():
		#accept_event()


func _input(e : InputEvent):
	# Don't process input if console is not visible
	if !is_visible_in_tree():
		return

	# Show next line in history
	if Input.is_action_just_pressed(ConsoleDefaultActions.CONSOLE_HISTORY_UP):
		self._current_command = Console.history.collection.current()
		Console.history.collection.previous()

		if self._tmp_user_entered_command == null:
			self._tmp_user_entered_command = self.text

	# Show previous line in history
	if Input.is_action_just_pressed(ConsoleDefaultActions.CONSOLE_HISTORY_DOWN):
		self._current_command = Console.history.collection.next()

#		if self._current_command != null and self._tmp_user_entered_command != null:
#				self._current_command = self._tmp_user_entered_command
#				self._tmp_user_entered_command = null

	# Autocomplete on TAB
	if Input.is_action_just_pressed(ConsoleDefaultActions.CONSOLE_AUTOCOMPLETE):
		if self._autocomplete_triggered_timer and self._autocomplete_triggered_timer.get_time_left() > 0:
			self._autocomplete_triggered_timer = null
			var actual_text = self.text
			if actual_text.begins_with(COMMAND_PREFIX):
				actual_text = actual_text.right(-1)
			var commands = Console.get_command_service().find(actual_text)
			if commands.length == 1:
				self.set_text(COMMAND_PREFIX + commands.get_by_index(0).get_name())
			elif commands.length > 1:
				Console.write_line('[color=#ffff33]=== POSSIBLE COMMANDS ===[/color]')
				for command in commands.get_value_iterator():
					var name = command.get_name()
					Console.write_line(COMMAND_PREFIX + '[color=#ffff66][url=%s]%s[/url][/color]' % [ name, name ])
		else:
			self._autocomplete_triggered_timer = get_tree().create_timer(1.0, true)
			var autocompleted_command = Console.get_command_service().autocomplete(self.text)
			self.set_text(autocompleted_command)

	# Finish
	if self._current_command != null:
		self.set_text(self._current_command.getText() if self._current_command and typeof(self._current_command) == TYPE_OBJECT else self._current_command)
		self.accept_event()
		self._current_command = null


func set_text(text : String, move_caret_to_end : bool = true):
	self.text = text
	self.grab_focus()

	if move_caret_to_end:
		self.caret_column = text.length()


func execute(raw_input : String):
	if raw_input.is_empty():
		return
	
	var input : String = raw_input
	if Console.use_prefix_for_commands:
		if not input.begins_with(COMMAND_PREFIX):
			if not Console.default_command.is_empty() and Console.default_command.length():
				input = COMMAND_PREFIX + Console.default_command + COMMAND_PARTS_SEPARATOR + input
			else:
				self.clear()
				return
		input = input.right(-1)

	if Console.print_command_in_console:
		Console.write_line('[color=#999999]/[/color] ' + input)
		
	var parsedCommands : Array = _parse_commands(input)

	for parsedCommand in parsedCommands:
		if parsedCommand.name.length():
			# @var  Command/Command|null
			var command = Console.get_command(parsedCommand.name)

			if command:
				Console.log.debug('Executing `' + parsedCommand.command + '`.')
				if command._arg_type == command.ArgType.STRING:
					var arg_string : String
					for i in parsedCommand.arguments.size():
						arg_string += parsedCommand.arguments[i] + COMMAND_PARTS_SEPARATOR
					parsedCommand.arguments = [ arg_string ]
				command.execute(parsedCommand.arguments)
				Console.emit_signal("command_executed", command)
			else:
				Console.write_line('Command `' + parsedCommand.name + '` not found.')
				Console.emit_signal("command_not_found", parsedCommand.name)
	
	Console.emit_signal("raw_input", raw_input)
	self.clear()


static func _parse_commands(input : String) -> Array[Dictionary]:
	var result_commands : Array[Dictionary] = []

	# @var  PoolStringArray
	var raw_commands = RegExLib.split(RECOMMANDS_SEPARATOR, input)
	for raw_command in raw_commands:
		if raw_command:
			result_commands.append(_parse_command(raw_command))

	return result_commands


static func _parse_command(raw_command : String, string_formatted_args : bool = true) -> Dictionary:
	var name = ''
	var arguments : Array[String]

	var beginning = 0  # int
	var open_quote  # String|null
	var is_inside_quotes : bool = false  # boolean
	var sub_string  # String|null
	for i in raw_command.length():
		# Quote
		if raw_command[i] in QUOTES and \
				(i == 0 or i > 0 and not raw_command[i - 1] in SCREENERS):
			if is_inside_quotes and raw_command[i] == open_quote:
				open_quote = null
				is_inside_quotes = false
				sub_string = raw_command.substr(beginning, i - beginning)
				beginning = i + 1
			elif !is_inside_quotes:
				open_quote = raw_command[i]
				is_inside_quotes = true
				beginning += 1

		# Separate arguments
		elif raw_command[i] == COMMAND_PARTS_SEPARATOR and !is_inside_quotes or i == raw_command.length() - 1:
			if i == raw_command.length() - 1:
				sub_string = raw_command.substr(beginning, i - beginning + 1)
			else:
				sub_string = raw_command.substr(beginning, i - beginning)
			beginning = i + 1

		# Save separated argument
		if sub_string != null and typeof(sub_string) == TYPE_STRING and !sub_string.is_empty():
			if name.is_empty():
				name = sub_string
			else:
				arguments.append(sub_string)
			sub_string = null

	return {
		'command': raw_command,
		'name': name,
		'arguments': arguments
	}


func _set_readonly(value):
	Console.log.warn('QC/Console/ConsoleLine: _set_readonly: Attempted to set a protected variable, ignoring.')
