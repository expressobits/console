extends Node
class_name ConsoleChat

signal received_message(id : int, message : String)
signal sended_message(message : String)
signal player_entered_messaged(id : int)
signal player_exited_message(id : int)

var is_active := false
var player_names : Dictionary

@export var debug_messages := false

func _ready():
#	multiplayer.peer_connected.connect(player_connected.bind())
	multiplayer.peer_disconnected.connect(_player_disconnected.bind())


func start():
	Console.add_command('chat', self, 'send')\
		.set_description('Send chat message')\
		.add_argument('message', TYPE_STRING)\
		.set_arg_type(ConsoleCommand.ArgType.STRING)\
		.register()
	if debug_messages:
		Console.log.info("Start chat service...")
	is_active = true


func stop():
	Console.default_command = ''
	Console.remove_command('chat')
	if debug_messages:
		Console.log.info("Stop chat service...")
	is_active = false


func player_setup(id : int, name : String):
	player_names[id] = name


func player_connected(id : int):
	_enter_message(id)
	if not is_active:
		start()


func _player_disconnected(id : int):
	_exit_message(id)
	if is_active:
		if multiplayer.get_unique_id() == id:
			stop()
	player_names.erase(id)


func send(message):
	emit_signal("sended_message", message)
	_send_rpc.rpc(message)


@rpc("any_peer", "call_local", "reliable" , 1)
func _send_rpc(message : String):
	var id = multiplayer.get_remote_sender_id()
	_receive(id, message)


func _receive(id, message):
	if not is_active:
		return
	emit_signal("received_message", id, message)
	var name_of_message = player_names[id]
	Console.write_line(str("[color=#ffff66][",name_of_message,"][/color] ",message))


func _enter_message(id):
	if not is_active:
		return
	emit_signal("player_entered_messaged", id)
	var name_of_message = player_names[id]
	Console.write_line(str("[color=#ffff66]",name_of_message," joined the server.[/color]"))


func _exit_message(id):
	if not is_active:
		return
	emit_signal("player_exited_message", id)
	var name_of_message = player_names[id]
	Console.write_line(str("[color=#ffff66]",name_of_message," left the server.[/color]"))
