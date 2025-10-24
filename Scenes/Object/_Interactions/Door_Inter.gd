extends Interaction

@onready var hinge: Node3D = %Hinge
@export var target_opening: int = 90
@export var opening_time: float = 0.2
var open: bool

func interact() -> void:
	open = !open
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(hinge, "rotation_degrees", Vector3(0, target_opening if open else 0 ,0), opening_time).set_trans(Tween.TRANS_QUART)
	##rebake navmesh
