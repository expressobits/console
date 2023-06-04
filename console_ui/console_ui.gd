extends Panel
class_name ConsoleUI

@onready var Text : ConsoleLogsUI = $Container/ConsoleText
@onready var Line = $Container/ConsoleLine:
	set(value): 
		_set_readonly(value)
@onready var _animation_player = $AnimationPlayer

# @var  Control
var previous_focus_owner = null

# @returns  void
func _set_readonly(value):
	Console.Log.warn('qc/console: _set_readonly: Attempted to set a protected variable, ignoring.')

func _ready():
	# React to clicks on console urls
#	self.Text.connect("meta_clicked", self.Line.set_text)
	
	# Hide console by default
	hide()
	_animation_player.connect("animation_finished", _toggle_animation_finished)
	Console.toggled.connect(_on_console_toggle_console.bind())
	

func _on_console_toggle_console(is_console_shown : bool):
	if is_console_shown:
		previous_focus_owner = self.Line.get_viewport().gui_get_focus_owner()
		show()
		self.Line.clear()
		self.Line.grab_focus()
		self._animation_player.play_backwards('fade')
	else:
		self.Line.accept_event() # Prevents from DefaultActions.console_toggle key character getting into previous_focus_owner value
		if is_instance_valid(previous_focus_owner):
			previous_focus_owner.grab_focus()
		previous_focus_owner = null
		self._animation_player.play('fade')


# @returns  void
func _toggle_animation_finished(animation):
	if not Console.is_console_shown:
		hide()
