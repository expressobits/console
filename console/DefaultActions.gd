
# @const  String
const CONSOLE_TOGGLE = "console_toggle"
# @const  Dictionary
const console_toggle_props = {
	"name": CONSOLE_TOGGLE,
	"events": [
		{
			"ctrl_pressed": true,
			"keycode": KEY_QUOTELEFT,
		}
	]
}

const CLOSE_CONSOLE = "close_console"
# @const  Dictionary
const close_console_props = {
	"name": CLOSE_CONSOLE,
	"events": [
		{
			"keycode": KEY_ESCAPE,
		}
	]
}


const OPEN_CONSOLE = "open_console"
# @const  Dictionary
const open_console_props = {
	"name": OPEN_CONSOLE,
	"events": [
		{
			"keycode": KEY_ENTER,
		}
	]
}

# @const  String
const CONSOLE_AUTOCOMPLETE = "console_autocomplete"
# @const  Dictionary
const console_autocomplete_props = {
	"name": CONSOLE_AUTOCOMPLETE,
	"events": [
		{
			"keycode": KEY_TAB,
		}
	]
}

# @const  String
const CONSOLE_HISTORY_UP = "console_history_up"
# @const  Dictionary
const console_history_up_props = {
	"name": CONSOLE_HISTORY_UP,
	"events": [
		{
			"keycode": KEY_UP,
		}
	]
}

# @const  String
const CONSOLE_HISTORY_DOWN = "console_history_down"
# @const  Dictionary
const console_history_down_props = {
	"name": CONSOLE_HISTORY_DOWN,
	"events": [
		{
			"keycode": KEY_DOWN,
		}
	]
}

# @var  Array
const ACTIONS = [
	console_toggle_props,
	console_autocomplete_props,
	console_history_up_props,
	console_history_down_props,
	open_console_props,
	close_console_props
]

static func register():
	# Register input events
	for action_props in ACTIONS:
		var setting_name = "input/" + action_props["name"]

		if not ProjectSettings.has_setting(setting_name):
			var events = []

			var action_props_events = action_props["events"]

			for event_data in action_props_events:
				var event = InputEventKey.new()
				for prop_name in event_data:
					event.set(prop_name, event_data[prop_name])

				events.append(event)

			ProjectSettings.set_setting(setting_name, {
				"deadzone": float(action_props["deadzone"] if "deadzone" in action_props else 0.5),
				"events": events
			})

	var result = ProjectSettings.save()
	assert(result == OK, "Failed to save project settings")
