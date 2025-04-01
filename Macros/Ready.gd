@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["rdy", "ready"]


static func is_macro_alias(data: MagicMacrosLineData) -> bool:
	return data.arg in ALIASES


static func apply_macro(_line_data: MagicMacrosLineData) -> String:
	var s: String = ""
	s += "func _ready() -> void:"
	s += "\n"
	s += "	pass"
	
	return s
