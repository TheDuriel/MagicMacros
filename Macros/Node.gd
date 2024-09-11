@tool
extends MagicMacrosMacro

const ALIASES: Array[String] = ["node"]


static func matches_macro(line: String) -> bool:
	var args: Array[String] = MagicMacrosMacro.get_args(line)
	return args[0] in ALIASES if not args.is_empty() else false


static func apply_macro(line: String) -> String:
	var args: Array[String] = MagicMacrosMacro.get_args(line)
	if args.is_empty():
		return line + "error"
	if not args[0] in ALIASES:
		return line + "error"
	
	var name: String = "NONAME" if not args.size() > 1 else args[1]
	var type: String = "Node" if not args.size() > 2 else args[2]
	var value: String = "NOVALUE" if not args.size() > 2 else args[2]
	
	match args.size():
		0:
			return "@onready var NONAME: Node"
		1:
			return "@onready var %s: Node" % name
		2:
			return "@onready var %s: %s" % [name, type]
		3:
			return "@onready var %s: %s = %s" % [name, type, value]
	
	return line + "error"
