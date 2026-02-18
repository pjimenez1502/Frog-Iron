extends Area3D
class_name CharacterTooltipArea

@onready var character_profile: CharacterProfile = %CharacterProfile

func _on_mouse_entered() -> void:
	SignalBus.CharacterTooltipShow.emit(true, get_parent().global_position, character_profile.get_data())

func _on_mouse_exited() -> void:
	SignalBus.CharacterTooltipShow.emit(false)
