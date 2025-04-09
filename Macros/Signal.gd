# Example
# sig on_test one two int Type.EnumName
#
# signal on_test(one: int, two: Type.EnumName)
#
# func emit_on_test(one: int, two: Type.EnumName) -> void:
#	 on_test.emit(one, two)

@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["sig"]

static var s: String
static var identifiers: Array[String]
static var types: Array[String]


static func is_macro_alias(arg: String) -> bool:
	return arg in ALIASES


static func apply_macro(line_data: MagicMacrosLineData) -> String:
	identifiers = line_data.identifier_args.duplicate()
	types = line_data.type_args.duplicate()
	
	var method_parameters: String = create_parameters(true)
	var passed_in_parameters = create_parameters(false)
	
	s  = "signal %s(%s)\n\n" % [identifiers[0], method_parameters]
	s += "func emit_%s(%s) -> void:\n" % [identifiers[0], method_parameters]
	s += "	%s.emit(%s)\n" %  [identifiers[0], passed_in_parameters]
	
	return s


static func create_parameters(method_signature: bool) -> String:
	var parameters: String = ""
	var template: String = "%s: %s" if method_signature else "%s"
	
	for i in types.size():
		if method_signature:
			parameters += template % [identifiers[i + 1], types[i]]
		else:
			parameters += template % identifiers[i + 1]
			
		if i < types.size() - 1:
			parameters += ", "
	
	return parameters
