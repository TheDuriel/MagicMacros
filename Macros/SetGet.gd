@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["setget", "sg"]


static func is_macro_alias(arg: String) -> bool:
	return arg in ALIASES


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	var s: String = ""
	s += "var %s: %s = %s:\n" % [line_data.identifier, line_data.type, line_data.remainder]
	s += "	set(value):\n"
	s += "		%s = value\n" % line_data.identifier
	s += "	get:\n"
	s += "		return %s\n" % line_data.identifier
	
	return s
