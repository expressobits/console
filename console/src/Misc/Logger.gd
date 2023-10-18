class_name Logger
extends RefCounted


enum LogType \
{
	DEBUG,
	INFO,
	WARNING,
	ERROR,
	NONE
}

var logLevel : LogType = LogType.WARNING


func set_log_level(in_log_level : LogType) -> Logger:
	logLevel = in_log_level
	return self

# Example usage:
# ```gdscript
# Console.Log.log("Hello world!", Console.Log.TYPE.INFO)
# ```
func log(message : String, type = LogType.INFO) -> Logger:
	match type:
		LogType.DEBUG:   debug(message)
		LogType.INFO:    info(message)
		LogType.WARNING: warn(message)
		LogType.ERROR:   error(message)
	return self


func debug(message : String) -> Logger:
	if logLevel <= LogType.DEBUG:
		Console.write_line('[color=green][DEBUG][/color] ' + str(message))
	return self


func info(message : String) -> Logger:
	if logLevel <= LogType.INFO:
		Console.write_line('[color=blue][INFO][/color] ' + str(message))
	return self


func warn(message : String) -> Logger:
	if logLevel <= LogType.WARNING:
		Console.write_line('[color=yellow][WARNING][/color] ' + str(message))
	return self


func error(message : String) -> Logger:
	if logLevel <= LogType.ERROR:
		Console.write_line('[color=red][ERROR][/color] ' + str(message))
	return self
