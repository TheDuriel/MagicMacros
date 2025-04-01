@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["node"]


static func is_macro_alias(data: MagicMacrosLineData) -> bool:
	return data.arg in ALIASES


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	var s: String = "@onready var %s: %s = %s" % [line_data.identifier, line_data.type, line_data.remainder]
	return s
