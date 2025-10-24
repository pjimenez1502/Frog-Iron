extends Interaction

@onready var hinge: Node3D = %Hinge
@export var target_opening: int = 90
@export var opening_time: float = 0.5

var open: bool

func door_interaction(value: bool) -> void:
	swing_door(value)

func swing_door(value) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(hinge, "rotation_degrees", Vector3(0, target_opening if value else 0 ,0), opening_time).set_trans(Tween.TRANS_QUART)
	await tween.finished
	SignalBus.NavmeshBakeRequest.emit()

func interact() -> void:
	open = !open
	door_interaction(open)

func interact_valued(value: bool) -> void:
	door_interaction(value)
