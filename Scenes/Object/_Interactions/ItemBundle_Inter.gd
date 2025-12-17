extends ChestInteraction
class_name ItemBundleInteraction

func interact() -> void:
	pass
func on_enter(_body: Node3D) -> void:
	open_chest(true)
func on_exit(_body: Node3D) -> void:
	super.on_exit(_body)
