@tool
extends EditorPlugin

const PLUGIN_NAME = 'Console'
const PLUGIN_PATH = 'res://addons/console/console/src/console.tscn'


func _enter_tree():
#	self.add_autoload_singleton(PLUGIN_NAME, PLUGIN_PATH)
	ConsoleDefaultActions.register()
