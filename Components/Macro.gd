@tool
class_name MagicMacrosMacro
extends RefCounted


static func is_macro_alias(arg: String) -> bool:
	return arg in []


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	return line_data.source_text
