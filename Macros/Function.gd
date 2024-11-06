@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["fn", "fnc"]


static func is_macro_alias(arg: String) -> bool:
	return arg in ALIASES


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	var s: String = ""
	s += "func %s() -> %s:" % [line_data.identifier, line_data.type]
	s += "\n"
	s += "	pass"
	return s
