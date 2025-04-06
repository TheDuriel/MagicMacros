@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["vars", "vs"]


static func is_macro_alias(arg: String) -> bool:
	return arg in ALIASES


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	var identifiers: Array[String] = line_data.identifier_args.duplicate()
	var types: Array[String] = line_data.type_args.duplicate()
	var values: Array[String] = line_data.remainder_args.duplicate()
	
	var s: String = ""
	
	for idx: int in identifiers.size():
		var identifier: String = identifiers[idx]
		var type: String = types[min(idx, types.size() - 1)] if not types.is_empty() else "type"
		var value: String = values[min(idx, values.size() - 1)] if not values.is_empty() else "null"
		
		var ss: String = line_data.indent + "var %s: %s = %s" % [identifier, type, value]
		s += ss
		if not idx == identifiers.size() - 1:
			s += "\n"
	
	return s
