@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["fn", "fnc"]


static func is_macro_alias(arg: String) -> bool:
	return arg in ALIASES


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	var s: String = ""
	s += "func %s() -> %s:" % [line_data.get_arg(0,"function"), line_data.get_arg(1,"void")]
	s += "\n"
	if line_data.get_arg(1,"void") == "void":
		s += "	pass"
	else:
		s += "	var value: %s"% [line_data.get_arg(1,"void")]
		s += "\n"
		s += "	return value"
	return s
