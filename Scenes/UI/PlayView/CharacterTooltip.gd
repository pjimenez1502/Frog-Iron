extends PanelContainer
class_name CharacterTooltip

func _ready() -> void:
	SignalBus.CharacterTooltipShow.connect(show_tooltip)

func show_tooltip(value: bool, position: Vector3 = Vector3.ZERO, data: Dictionary = {}) -> void:
	print(value)
