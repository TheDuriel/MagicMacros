@tool
class_name MagicMacros
extends EditorPlugin

const MACROS_DIR: String = "res://addons/MagicMacros/Macros/"

const THEME_COLOR_CONSTANT: String = "current_line_color"
const THEME_COLOR_VALID: Color = Color(0.0, 1.0, 0.0, 0.15) # Color to highlight valid macro with
const PASCAL_CASE_REGEX_PATTERN: String = '^[A-Z][a-zA-Z0-9]*$'
const SNAKE_CASE_REGEX_PATTERN: String = '^[a-z0-9_]+$'

# Sudo const :D
var macros_alias_func: String = MagicMacrosMacro.is_macro_alias.get_method()
var macros_apply_func: String = MagicMacrosMacro.apply_macro.get_method()

var pascal_case_regex: RegEx
var snake_case_regex: RegEx

var macros: Array[Script] = []


var _current_editor: ScriptEditorBase:
	set(value):
		if value == _current_editor:
			return
		
		var base: TextEdit
		
		if _current_editor:
			base = _current_editor.get_base_editor()
			if base:
				base.text_changed.disconnect(_on_text_changed)
				base.caret_changed.disconnect(_on_caret_changed)
			
		_current_editor = value
		
		if _current_editor:
			base = _current_editor.get_base_editor()
			if base:
				base.text_changed.connect(_on_text_changed)
				base.caret_changed.connect(_on_caret_changed)

var _current_line_data: MagicMacrosLineData:
	set(value):
		_current_line_data = value
		_update_line_color()


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	_load_macros()
	EditorInterface.get_script_editor().editor_script_changed.connect(_on_script_changed)
	var InputCatcher:MagicMacrosInputCatcher = MagicMacrosInputCatcher.new()
	InputCatcher.tab_pressed.connect(_on_tab_pressed)
	_current_editor = EditorInterface.get_script_editor().get_current_editor()
	pascal_case_regex = RegEx.new()
	pascal_case_regex.compile(PASCAL_CASE_REGEX_PATTERN)
	snake_case_regex = RegEx.new()
	snake_case_regex.compile(SNAKE_CASE_REGEX_PATTERN)
	print("MagicMacros: Enabled")



func _exit_tree() -> void:
	if _current_editor:
		var base: TextEdit = _current_editor.get_base_editor()
		base.remove_theme_color_override(THEME_COLOR_CONSTANT)



func _load_macros() -> void:
	var files: PackedStringArray = DirAccess.get_files_at(MACROS_DIR)
	for file: String in files:
		var file_path: String = MACROS_DIR.path_join(file)
		var script: Script = load(file_path)
		if script.has_method(macros_alias_func):
			macros.append(script)


func _on_script_changed(_script: Script) -> void:
	_current_editor = EditorInterface.get_script_editor().get_current_editor()
	_get_line_data()


func _on_text_changed() -> void:
	_get_line_data()


func _on_caret_changed() -> void:
	_get_line_data()


func _get_line_data() -> void:
	_current_line_data = null
	
	var base: TextEdit = _current_editor.get_base_editor()
	if not base:
		return
	var line_id: int = base.get_caret_line()
	var line_text: String = base.get_line(line_id)
	
	_current_line_data = MagicMacrosLineData.new(self, line_id, line_text)


func _update_line_color() -> void:
	var base: TextEdit = _current_editor.get_base_editor()
	if not base:
		return
	if not _current_line_data:
		return
	
	if _current_line_data.is_valid:
		base.add_theme_color_override(THEME_COLOR_CONSTANT, THEME_COLOR_VALID)
	else:
		base.remove_theme_color_override(THEME_COLOR_CONSTANT)


func _on_tab_pressed() -> void:
	var base: CodeEdit = _current_editor.get_base_editor()
	if not base:
		return
	if not base.is_visible_in_tree() and base.has_focus():
		return
	if not _current_line_data:
		return
	if not _current_line_data.is_valid:
		return
	
	base.set_line(_current_line_data.id, _current_line_data.modified_text)
	base.set_caret_column(0)
	base.set_caret_line(_current_line_data.id)
	base.cancel_code_completion()
	EditorInterface.get_script_editor().get_viewport().set_input_as_handled()

func is_pascal_case(string: String) -> bool:
	return true if pascal_case_regex.search(string) else false


func is_snake_case(string: String) -> bool:
	return true if snake_case_regex.search(string) else false
