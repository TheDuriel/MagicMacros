@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["twen", "tweeen","tw"]


static func is_macro_alias(arg: String) -> bool:
	return arg in ALIASES


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	var s: String = ""
	s += "	var tween: Tween = create_tween()\n"
	s += "	tween.tween_property(%s,\"%s\",%s,%s)\n" %[line_data.get_arg(0,"node"),line_data.get_arg(1,"property"),line_data.get_arg(2,"0.0"),line_data.get_arg(3,"1")]
	return s
