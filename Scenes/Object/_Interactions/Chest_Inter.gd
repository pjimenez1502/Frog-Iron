extends AutoInteraction
class_name ChestInteraction

@onready var hinge: Node3D = %Hinge
@export var target_opening: int = 90
@export var opening_time: float = 0.5

var locked: bool

func open_chest(value: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(hinge, "rotation_degrees", Vector3(target_opening if value else 0, 0, 0), opening_time).set_trans(Tween.TRANS_BACK)
	await tween.finished

func on_enter(body: Node3D) -> void:
	if locked:
		return
	open_chest(true)
	#open_inv

func on_exit(body: Node3D) -> void:
	open_chest(false)
	#close_inv
