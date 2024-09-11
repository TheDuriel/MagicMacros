@tool
extends MagicMacrosMacro


static func matches_macro(line: String) -> bool:
	var args: Array[String] = MagicMacrosMacro.get_args(line)
	return args[0] == "setget" if not args.is_empty() else false


static func apply_macro(line: String) -> String:
	var args: Array[String] = MagicMacrosMacro.get_args(line)
	if args.is_empty():
		return line + "error"
	if not args[0] == "setget":
		return line + "error"
	
	var name: String = "NONAME" if not args.size() > 1 else args[1]
	var type: String = "Variant" if not args.size() > 2 else args[2]
	var value: String = "NONE" if not args.size() > 3 else args[3]
	
	var s: String = ""
	s += "var %s: %s = %s:\n" % [name, type, value]
	s += "	set(value):\n"
	s += "		%s = value\n" % name
	s += "	get:\n"
	s += "		return %s\n" % name
	
	return s
