@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["vars"]


static func is_macro_alias(arg: String) -> bool:
	return arg in ALIASES


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	var s: String = ""
	if line_data.arguements.size()<4:
		s = "var %s: %s = %s" % [line_data.get_arg(0,"place_holder"), line_data.get_arg(1,"int"), line_data.get_arg(2,"0")]
	else:
		var last_index: int = line_data.arguements.size()-1
		var ind: int = line_data.arguements.size()-2
		if line_data.get_arg(1).is_valid_int():
			ind = line_data.get_arg(1).to_int()
			for i in ind:
				s+= "var %s: %s = %s\n\n" % [line_data.get_arg(last_index+1,"val"+str(i)), line_data.get_arg(last_index-1,"int"), line_data.get_arg(last_index,"0")]
		else:
			for i in ind:
				s+= "var %s: %s = %s\n\n" % [line_data.get_arg(i,"val"+str(i)), line_data.get_arg(last_index-1,"int"), line_data.get_arg(last_index,"0")]
	return s
