@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["init"]


static func matches_macro(line: String) -> bool:
	var args: Array[String] = MagicMacrosMacro.get_args(line)
	return args[0] in ALIASES if not args.is_empty() else false


static func apply_macro(line: String) -> String:
	var args: Array[String] = MagicMacrosMacro.get_args(line)
	if args.is_empty():
		return line + "error"
	if not args[0] in ALIASES:
		return line + "error"
	
	var s: String = ""
	s += "func _init() -> void:"
	s += "\n"
	s += "	pass"
	
	return s
