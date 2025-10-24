extends Node3D
class_name InteractableObject

@onready var interaction: Interaction = %Interaction
var active: bool
func set_active(value: bool) -> void:
	active = value

func interact() -> void:
	interaction.interact()

func interact_valued(value: bool) -> void:
	interaction.interact_valued(value)
