class_name MagicMacrosInputCatcher
extends Node
# Catches inputs in owning window.
# This is really awkward but the only solution I can see working.
# One of these gets attached to every engine window unless it already has one.
# Yeah that's fucked.

signal tab_pressed(window: Window)

var _window: Window


func _init(window: Window) -> void:
	_window = window
	_window.add_child(self)


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	
	var e: InputEventKey = event
	
	if not e.keycode == KEY_TAB:
		return
	
	if e.is_released() and not e.echo:
		tab_pressed.emit(_window)
