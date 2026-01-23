extends Button
class_name CustomRLButton

signal MouseLeft
signal MouseRight

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			MouseLeft.emit()
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			MouseRight.emit()
