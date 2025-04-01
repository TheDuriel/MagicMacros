@tool
class_name MagicMacros
extends EditorPlugin

const MACROS_DIR: String = "res://addons/MagicMacros/Macros/"

const THEME_COLOR_CONSTANT: String = "current_line_color"
# Color with which to highlight a valid macro with
const THEME_COLOR_VALID: Color = Color(0.0, 1.0, 0.0, 0.15)
# regex patterns used for argument detection. See LineData
const PASCAL_CASE_REGEX_PATTERN: String = '^[A-Z][a-zA-Z0-9]*$'
const SNAKE_CASE_REGEX_PATTERN: String = '^[a-z0-9_]+$'

var pascal_case_regex: RegEx
var snake_case_regex: RegEx

# This is a bit silly. But since the list of macros is dynamic and not constant
# This is the only "reasonable" way of reliably getting the method name to call() in LineData
var macros_alias_func: String = MagicMacrosMacro.is_macro_alias.get_method()
var macros_apply_func: String = MagicMacrosMacro.apply_macro.get_method()

# List of Macro Script resources found in MagicMacros/Macros
# Macros are not instanced, but statically called
var macros: Array[Script] = []

var _input_catcher: MagicMacrosInputCatcher

# While the ScriptEditor is always present, it will instance one CodeEditor per open script
# This mess is part of making sure that we only interact with the currently visible script editor
var _current_editor: ScriptEditorBase:
	set(value):
		if value == _current_editor:
			return
		
		var base: TextEdit
		
		if is_instance_valid(_current_editor):
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

# LineData for the currently highlight line in the CodeEditor
var _current_line_data: MagicMacrosLineData:
	set(value):
		_current_line_data = value
		_update_line_color()


func _ready() -> void:
	# HACK: Fixes macros not loading? Unconfirmeed
	await get_tree().process_frame
	
	_load_macros()
	
	EditorInterface.get_script_editor().editor_script_changed.connect(_on_script_changed)
	
	_input_catcher = MagicMacrosInputCatcher.new()
	_input_catcher.tab_pressed.connect(_on_tab_pressed)
	
	_current_editor = EditorInterface.get_script_editor().get_current_editor()
	
	pascal_case_regex = RegEx.new()
	pascal_case_regex.compile(PASCAL_CASE_REGEX_PATTERN)
	snake_case_regex = RegEx.new()
	snake_case_regex.compile(SNAKE_CASE_REGEX_PATTERN)
	
	print("MagicMacros: %s macros enabled" % macros.size())


func _exit_tree() -> void:
	if _current_editor:
		var base: TextEdit = _current_editor.get_base_editor()
		base.remove_theme_color_override(THEME_COLOR_CONSTANT)
	
	if _input_catcher:
		_input_catcher.queue_free()
	
	print("MagicMacros: Disabled")


# TODO: Consider making this path configurable. But it's probably not worth the trouble.
func _load_macros() -> void:
	var files: PackedStringArray = DirAccess.get_files_at(MACROS_DIR)
	for file: String in files:
		
		if file.ends_with(".remap") or file.ends_with(".uid"):
			continue
		
		var file_path: String = MACROS_DIR.path_join(file)
		var script: Script = load(file_path)
		if script.has_method(macros_alias_func):
			macros.append(script)


# When the currently edited script changes.
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
	
	_current_line_data = MagicMacrosLineData.new(self, line_id, line_text, EditorInterface.get_script_editor().get_current_script())


func _update_line_color() -> void:
	if not is_instance_valid(_current_editor):
		return
	
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
	
	_current_editor.get_viewport().set_input_as_handled()
	base.cancel_code_completion()
	
	base.set_line(_current_line_data.line_index, _current_line_data.modified_text)
	base.set_caret_column(0)
	base.set_caret_line(_current_line_data.line_index)
	
	base.cancel_code_completion()


func is_pascal_case(string: String) -> bool:
	return true if pascal_case_regex.search(string) else false


func is_snake_case(string: String) -> bool:
	return true if snake_case_regex.search(string) else false
