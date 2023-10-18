class_name ConsoleError

var _message : String
var _code


func _init(message : String, code = null):
  self._message = message
  self._code = code


func get_message() -> String:
  return self._message


func get_code():
  return self._code


func to_string() -> String:
  return self._message
