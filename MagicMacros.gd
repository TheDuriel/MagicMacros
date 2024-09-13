@tool
extends EditorPlugin

const MACROS_DIR: String = "res://addons/MagicMacros/Macros/"
const MACRO_MATCH_FUNC: String = "matches_macro"
const MACRO_APPLY_FUNC: String = "apply_macro"

const THEME_COLOR_CONSTANT: String = "current_line_color"
const THEME_COLOR_VALID: Color = Color(0.0, 1.0, 0.0, 0.15) # Color to highlight valid macro with

var _macros: Array[Script] = []

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

var _current_line_macro: Script = null



func _ready() -> void:
	_load_macros()
	EditorInterface.get_script_editor().script_changed.connect(_on_script_changed)
	_current_editor = EditorInterface.get_script_editor().get_current_editor()


func _exit_tree() -> void:
	if _current_editor:
		var base: TextEdit = _current_editor.get_base_editor()
		base.remove_theme_color_override(THEME_COLOR_CONSTANT)


func _input(event: InputEvent) -> void:
	if not _current_editor:
		return
	if not _current_editor.is_visible_in_tree():
		return
	
	if event is InputEventKey:
		if event.keycode == KEY_TAB:
			if event.is_echo() or event.is_released():
				return
			if event.pressed:
				_apply_macro()


func _load_macros() -> void:
	var files: PackedStringArray = DirAccess.get_files_at(MACROS_DIR)
	for file: String in files:
		var file_path: String = MACROS_DIR.path_join(file)
		var script: Script = load(file_path)
		if script.has_method(MACRO_MATCH_FUNC):
			_macros.append(script)


func _on_script_changed(_script: Script) -> void:
	_current_editor = EditorInterface.get_script_editor().get_current_editor()


func _on_text_changed() -> void:
	_check_for_macro()


func _on_caret_changed() -> void:
	_check_for_macro()


func _check_for_macro() -> void:
	var base: TextEdit = _current_editor.get_base_editor()
	if not base:
		return
	
	var pattern: Script = _find_line_macro(base)
	_current_line_macro = pattern
	
	if _current_line_macro:
		base.add_theme_color_override(THEME_COLOR_CONSTANT, THEME_COLOR_VALID)
	else:
		base.remove_theme_color_override(THEME_COLOR_CONSTANT)


func _find_line_macro(base: TextEdit) -> Script:
	var line: int = base.get_caret_line()
	var line_text: String = base.get_line(line)
	
	for macro: Script in _macros:
		var matches: bool = macro.call(MACRO_MATCH_FUNC, line_text)
		if matches:
			return macro
	
	return null


func _apply_macro() -> void:
	var base: TextEdit = _current_editor.get_base_editor()
	if not base:
		return
	
	if not _current_line_macro:
		return
	
	var line: int = base.get_caret_line()
	var line_text: String = base.get_line(line)
	var new_line: String = _current_line_macro.call(MACRO_APPLY_FUNC, line_text)
	base.set_line(line, new_line)
	base.set_caret_column(0)
	base.set_caret_line(line)
	get_window().set_input_as_handled()
