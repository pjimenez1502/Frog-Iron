extends AutoInteraction
class_name ChestInteraction

@onready var chest: Chest = $".."

@onready var hinge: Node3D = %Hinge
@export var target_opening: int = 90
@export var opening_time: float = 0.5

func open_chest(value: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(hinge, "rotation_degrees", Vector3(target_opening if value else 0, 0, 0), opening_time).set_trans(Tween.TRANS_BACK)
	await tween.finished

func on_enter(_body: Node3D) -> void:
	if chest.locked:
		return
	open_chest(true)
	SignalBus.OpenEmergentInv.emit(chest.inventory)
	SignalBus.UpdateEmergentInv.connect(chest.update_inventory)

func on_exit(_body: Node3D) -> void:
	open_chest(false)
	SignalBus.CloseEmergentInv.emit()
	SignalBus.UpdateEmergentInv.disconnect(chest.update_inventory)
