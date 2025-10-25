extends ViewScene
class_name StartMenu

@onready var buttons: VBoxContainer = $Control/Buttons

func _ready() -> void:
	focus_first_button()

func focus_first_button() -> void:
	buttons.get_child(0).grab_focus()



func new_game() -> void:
	SignalBus.LaunchDemoScene.emit()

func load_game() -> void:
	pass

func open_settings() -> void:
	pass

func exit() -> void:
	get_tree().quit()
