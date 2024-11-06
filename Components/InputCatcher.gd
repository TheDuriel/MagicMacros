class_name MagicMacrosInputCatcher
extends Node
# This class intercepts inputs meant for the CodeEditor

signal tab_pressed


func _init()->void:
	EditorInterface.get_script_editor().add_child(self)


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	
	var e: InputEventKey = event
	
	if not e.keycode == KEY_TAB:
		return
	
	if e.pressed and not e.is_echo() and not e.is_released():
		tab_pressed.emit()
