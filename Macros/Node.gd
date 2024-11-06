@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["node"]


static func is_macro_alias(arg: String) -> bool:
	return arg in ALIASES


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	var s: String = "@onready var %s: %s = %s" % [line_data.get_arg(0,"place_holder"), line_data.get_arg(1,"Node"), line_data.get_arg(2,"Node.new()")]
	return s
