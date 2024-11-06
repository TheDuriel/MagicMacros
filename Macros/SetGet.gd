@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["setget", "sg"]


static func is_macro_alias(arg: String) -> bool:
	return arg in ALIASES


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	var s: String = ""
	s += "var %s: %s = %s:\n" % [line_data.get_arg(0), line_data.get_arg(1,"int"), line_data.get_arg(2,"0")]
	s += "	set(value):\n"
	s += "		%s = value\n" % line_data.get_arg(0)
	s += "	get:\n"
	s += "		return %s\n" % line_data.get_arg(0)
	
	return s
