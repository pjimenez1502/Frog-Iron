extends Node3D
class_name InteractableObject

@export var locked: bool
@onready var interaction: Interaction = %Interaction

#var active: bool
#func set_active(value: bool) -> void:
	#active = value

func interact() -> void:
	if locked:
		return
	interaction.interact()

func interact_valued(value: bool) -> void:
	interaction.interact_valued(value)
