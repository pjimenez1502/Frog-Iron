extends Area3D
class_name CharacterTooltipArea

@onready var character_profile: CharacterProfile = %CharacterProfile

func _on_mouse_entered() -> void:
	SignalBus.CharacterTooltipShow.emit(true, self, character_profile.get_data())

func _on_mouse_exited() -> void:
	SignalBus.CharacterTooltipShow.emit(false, self)

func on_death() -> void:
	SignalBus.CharacterTooltipShow.emit(false, self)
