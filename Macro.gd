@tool
class_name MagicMacrosMacro
extends RefCounted


static func matches_macro(line: String) -> bool:
	if line.begins_with("NONE"):
		return true
	return false


static func apply_macro(line: String) -> String:
	return line


static func get_args(line: String) -> Array:
	var args: PackedStringArray = line.split(" ", false)
	var rargs: Array[String]
	for arg: String in args:
		if not arg == "" and not arg == " ":
			rargs.append(arg)
	return rargs
