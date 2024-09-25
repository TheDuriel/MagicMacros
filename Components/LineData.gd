class_name MagicMacrosLineData
extends RefCounted

const DEFAULT_IDENTIFIER: String = "identifier"
const DEFAULT_TYPE: String = "type"
const DEFAULT_REMAINDER: String = "none"

var id: int = -1
var source_text: String = ""
var modified_text: String:
	get:
		if not is_valid:
			return source_text
		return detected_macro.call(_plugin.macros_apply_func, self)

var detected_macro: Script
var macro_arg: String = ""

var identifier_args: Array[String] = []

var has_identifier: bool:
	get: return not identifier_args.is_empty()

var identifier: String:
	get: return identifier[0] if has_identifier else DEFAULT_IDENTIFIER

var type_args: Array[String] = []

var has_type: bool:
	get: return not type_args.is_empty()

var type: String:
	get: return type_args[0] if has_type else DEFAULT_TYPE

var remainder_args: Array[String] = []

var has_remainder: bool:
	get: return not remainder_args.is_empty()

var remainder: String:
	get: return remainder_args[0] if has_remainder else DEFAULT_REMAINDER

var is_valid: bool:
	get: return true if detected_macro else false

var _plugin: MagicMacros


func _init(plugin: MagicMacros, line_id: int, line_text: String) -> void:
	_plugin = plugin
	id = line_id
	source_text = line_text
	_parse_line()


func _parse_line() -> void:
	var args: PackedStringArray = source_text.split(" ", false)
	if args.is_empty():
		return
	
	if _arg_is_macro(args[0]):
		macro_arg = args[0]
		args.remove_at(0)
	
	var types: Array[String] = []
	var identifiers: Array[String] = []
	var remainders: Array[String] = []
	
	for arg: String in args:
		if _arg_is_type(arg):
			types.append(arg)
		elif _arg_is_identifier(arg):
			identifiers.append(arg)
		else:
			remainders.append(arg)
	
	type_args = types
	identifier_args = identifiers
	remainder_args = remainders
	
	detected_macro = _get_macro_script()


func _arg_is_macro(arg: String) -> bool:
	for macro: Script in _plugin.macros:
		if macro.call(_plugin.macros_alias_func, arg):
			return true
	return false


func _arg_is_type(arg: String) -> bool:
	return _plugin.is_pascal_case(arg)


func _arg_is_identifier(arg: String) -> bool:
	return _plugin.is_snake_case(arg)


func _get_macro_script() -> Script:
	for macro: Script in _plugin.macros:
		var matches: bool = macro.call(_plugin.macros_alias_func, source_text)
		if matches:
			return macro
	
	return null
