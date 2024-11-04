@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["init"]


static func is_macro_alias(arg: String) -> bool:
	return arg in ALIASES


static func apply_macro(_line_data: MagicMacrosLineData) -> String:
	var s: String = ""
	s += "func _init() -> void:"
	s += "\n"
	s += "	pass"
	
	return s
