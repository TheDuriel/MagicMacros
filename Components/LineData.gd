class_name MagicMacrosLineData
extends RefCounted


var id: int = -1
var source_text: String = ""
var modified_text: String:
	get:
		if not is_valid:
			return source_text
		return detected_macro.call(_plugin.macros_apply_func, self)

var detected_macro: Script
var macro_arg: String = ""

var arguements: PackedStringArray
var is_valid: bool:
	get: return true if detected_macro else false

var _plugin: MagicMacros


func _init(plugin: MagicMacros, line_id: int, line_text: String) -> void:
	_plugin = plugin
	id = line_id
	source_text = line_text
	_parse_line()

func get_arg(index: int, default: String = "default")->String:
	if index < arguements.size():
		return arguements[index]
	return default


func _parse_line() -> void:
	var args: PackedStringArray = source_text.split(" ", false)
	if args.is_empty():
		return
	
	if _arg_is_macro(args[0]):
		macro_arg = args[0]
		args.remove_at(0)
	
	arguements = args
	
	detected_macro = _get_macro_script()


func _arg_is_macro(arg: String) -> bool:
	for macro: Script in _plugin.macros:
		if macro.call(_plugin.macros_alias_func, arg):
			return true
	return false


func _get_macro_script() -> Script:
	for macro: Script in _plugin.macros:
		var matches: bool = macro.call(_plugin.macros_alias_func, macro_arg)
		if matches:
			return macro
	return null
