extends Interaction
class_name DoorInteraction

enum DoorType {Hinge, SlideDown, SlideSide}

@onready var hinge: Node3D = %Hinge
@onready var collision_shape_3d: CollisionShape3D = $"../CollisionShape3D"

@export var door_type: DoorType
@export var target_opening: int = 90
@export var opening_time: float = 0.5

var open: bool

func door_interaction(value: bool) -> void:
	match door_type:
		DoorType.Hinge:
			swing_door(value)
		DoorType.SlideDown:
			slide_door_down(value)
		DoorType.SlideSide:
			slide_door_side(value)
		
func swing_door(value: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(hinge, "rotation_degrees", Vector3(0, target_opening if value else 0, 0), opening_time).set_trans(Tween.TRANS_QUART)
	await tween.finished
	SignalBus.NavmeshBakeRequest.emit()

func slide_door_down(value: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(hinge, "position", Vector3(0, -target_opening if value else 0, 0), opening_time).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	SignalBus.NavmeshBakeRequest.emit()

func slide_door_side(value: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(hinge, "position", Vector3(target_opening if value else 0, 0, 0), opening_time).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	SignalBus.NavmeshBakeRequest.emit()

func interact() -> void:
	open = !open
	collision_shape_3d.disabled = open
	door_interaction(open)

func interact_valued(value: bool) -> void:
	door_interaction(value)
