@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["fn", "fnc"]


static func matches_macro(line: String) -> bool:
	var args: Array[String] = MagicMacrosMacro.get_args(line)
	return args[0] in ALIASES if not args.is_empty() else false


static func apply_macro(line: String) -> String:
	var args: Array[String] = MagicMacrosMacro.get_args(line)
	if args.is_empty():
		return line + "error"
	if not args[0] in ALIASES:
		return line + "error"
	
	var name: String = "NONAME" if not args.size() > 1 else args[1]
	var type: String = "Variant" if not args.size() > 2 else args[2]
	
	var s: String = ""
	s += "func %s() -> %s:" % [name, type]
	s += "	pass"
	
	return s
