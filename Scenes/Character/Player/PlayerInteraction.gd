extends Area3D
class_name PlayerInteraction

@onready var interaction_ui: Node3D = %InteractionUI

var interactables: Array[InteractableObject]
var closest_interactable: InteractableObject

func _input(event: InputEvent) -> void:
	if !closest_interactable:
		return
	if event.is_action_pressed("INTERACT"):
		closest_interactable.interact()

func find_closest_interactable() -> void:
	if !interactables:
		closest_interactable = null
		interaction_ui.visible = false
		return
	for i_interactable: InteractableObject in interactables:
		i_interactable.active = false
		if !closest_interactable:
			closest_interactable = i_interactable
		if Util.first_closer(global_position, i_interactable.global_position, closest_interactable.global_position):
			closest_interactable = i_interactable
	if closest_interactable:
		interaction_ui.visible = true
		interaction_ui.global_position = closest_interactable.global_position
		closest_interactable.active = true

#func _on_area_entered(area: Area3D) -> void:
	#interactables.append(area.get_parent())
#func _on_area_exited(area: Area3D) -> void:
	#if !interactables.has(area.get_parent()):
		#return
	#interactables.erase(area.get_parent())
