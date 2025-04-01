@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["ov"]

static func is_macro_alias(data: MagicMacrosLineData) -> bool:
	var args = data.args
	if args.size() < 2 or args[1].is_empty():
		return false
	if args[0] not in ALIASES:
		return false
	if get_unique_method(data.source_script, args[1]):
		return true
	return false

static func get_unique_method(script: GDScript, prefix: String) -> Dictionary:
	if not script.get_base_script():
		return {}
		
	var methods: Dictionary[String, Dictionary]
	for dict in script.get_base_script().get_script_method_list():
		if dict.name.begins_with(prefix):
			methods[dict.name] = dict
	
	for m in methods:
		print(m)
	
	if methods.size() == 1:
		return methods.values()[0]
	return {}
	
static func apply_macro(line_data: MagicMacrosLineData) -> String:
	var method := get_unique_method(line_data.source_script, line_data.identifier)
	var return_name = get_type_name(method.return)
	var arg_strings = []
	for i in method.args.size():
		arg_strings.append(get_arg_string(method, i))
	var s: String = ""
	s += "func %s(%s) -> %s:" % [method.name, ", ".join(arg_strings), return_name]
	s += "\n"
	s += "	pass"
	return s


static func get_arg_string(method: Dictionary, index: int) -> String:
	var arg = method.args[index]
	var s = arg.name
	var t = get_type_name(arg)
	if t: s+=": "+t
	var default_args_index = index - method.args.size() + method.default_args.size()
	if default_args_index>=0:
		var default_arg = method.default_args[default_args_index]
		s+=" "
		if not t: s+=":"
		s+="= " + str(default_arg)
	return s

static func get_type_name(d: Dictionary):
	if d.class_name: return d.class_name
	if d.type: return type_string(d.type)
	return "Variant"
