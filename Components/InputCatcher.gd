class_name MagicMacrosInputCatcher
extends Node
# Catches inputs in owning window.
# This is really awkward but the only solution I can see working.
# One of these gets attached to every engine window unless it already has one.
# Yeah that's fucked.

signal tab_pressed
var _window: Window



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
