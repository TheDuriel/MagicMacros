@tool
class_name MagicMacrosMacro
extends RefCounted


# Return true if the argument provided is the trigger for this macro.
# Eg: The ready macro uses "ready" and "rdy"
static func is_macro_alias(data: MagicMacrosLineData) -> bool:
	return data.arg in []


# Return the new line to be inserted
# Add line breaks using \n
# LineData provides all arguments detected in the line
static func apply_macro(line_data: MagicMacrosLineData) -> String:
	return line_data.source_text
