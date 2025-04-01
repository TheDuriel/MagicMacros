class_name MagicMacrosLineData
extends RefCounted
# Analyzes a provided Line to determine its contents and applicable macro.

const DEFAULT_IDENTIFIER: String = "identifier"
const DEFAULT_TYPE: String = "type"
const DEFAULT_REMAINDER: String = "none"
const NON_PASCAL_TYPES: Array[String] = ["void", "bool", "float", "int"]

# ID of the Line within its TextEditor
var line_index: int = -1
# The raw text of the line
var source_text: String = ""

# The output of the macro
var modified_text: String:
	get:
		if not is_valid:
			return source_text
		return detected_macro.call(_plugin.macros_apply_func, self)

# The macro applicable to this line, if any
var detected_macro: Script
# The argument with which the macro is detected.
var arg: String:
	get(): return args[0]
var args: Array:
	get(): return source_text.split(" ") 

# Identifiers detected within the line
# identifiers are always snake_case, follows GDScript style guide
var identifier_args: Array[String] = []

var has_identifier: bool:
	get: return not identifier_args.is_empty()

# Convenience helper value for retrieving the first identifier in the line.
var identifier: String:
	get: return identifier_args[0] if has_identifier else DEFAULT_IDENTIFIER

# Types detected within the line
# Types are always PascalCase, follows GDScript style guide
var type_args: Array[String] = []

var has_type: bool:
	get: return not type_args.is_empty()

# Convenience helper value for retrieving the first type in the line.
var type: String:
	get: return type_args[0] if has_type else DEFAULT_TYPE

# Any remaining arguments that are not identifiers or types
var remainder_args: Array[String] = []

var has_remainder: bool:
	get: return not remainder_args.is_empty()

# Convenience helper value for retreiving the first remainder value.
var remainder: String:
	get: return remainder_args[0] if has_remainder else DEFAULT_REMAINDER

var is_valid: bool:
	get: return true if detected_macro else false

# Reference to the plugin script
var _plugin: MagicMacros

var source_script: GDScript

func _init(plugin: MagicMacros, line_id: int, line_text: String, script: GDScript) -> void:
	_plugin = plugin
	line_index = line_id
	source_text = line_text
	source_script = script
	_parse_line()


func _parse_line() -> void:
	# Get the individual arguments
	var args: PackedStringArray = source_text.split(" ", false)
	if args.is_empty():
		return
	
	# The first argument must be a macro argument
	# Eg. 'fn' or 'rdy'
	if _arg_is_macro(args[0]):
		args.remove_at(0)
	
	var types: Array[String] = []
	var identifiers: Array[String] = []
	var remainders: Array[String] = []
	
	# Detect and sort arguments by category.
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
	
	# Retrieve the macro
	detected_macro = _get_macro_script()


func _arg_is_macro(arg: String) -> bool:
	for macro: Script in _plugin.macros:
		# Will return a bool. See MagicMacroMacro for this.
		if macro.call(_plugin.macros_alias_func, self):
			return true
	return false


func _arg_is_type(arg: String) -> bool:
	if arg in NON_PASCAL_TYPES:
		return true
	
	return _plugin.is_pascal_case(arg)


func _arg_is_identifier(arg: String) -> bool:
	return _plugin.is_snake_case(arg)


func _get_macro_script() -> Script:
	for macro: Script in _plugin.macros:
		var matches: bool = macro.call(_plugin.macros_alias_func, self)
		if matches:
			return macro
	return null
