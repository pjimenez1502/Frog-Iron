extends Interaction
class_name DoorInteraction

enum DoorType {Hinge, SlideDown, SlideSide}

@onready var hinge: Node3D = %Hinge
@onready var collision_shape_3d: CollisionShape3D = $"../CollisionShape3D"

@export var door_type: DoorType
@export var target_opening: int = 90
@export var opening_time: float = 0.5

var open: bool

func _ready() -> void:
	pass

func door_interaction() -> void:
	match door_type:
		DoorType.Hinge:
			swing_door(open)
		DoorType.SlideDown:
			slide_door_down(open)
		DoorType.SlideSide:
			slide_door_side(open)
	get_parent().update_is_vision_blocker(!open)
	SignalBus.EntityMapPointUpdate.emit(get_parent().tile_position, LevelMap.ENTITY_TYPE.EMPTY if open else LevelMap.ENTITY_TYPE.OBJECT)

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
	if check_door_ocuppied(): return
	
	open = !open
	collision_shape_3d.disabled = open
	door_interaction()

func interact_valued(value: bool) -> void:
	open = value
	door_interaction()

func check_door_ocuppied() -> bool:
	var entity_in_door: LevelMap.ENTITY_TYPE = GameDirector.level_map.get_entity_at_pos(get_parent().tile_position)
	if entity_in_door == LevelMap.ENTITY_TYPE.EMPTY or entity_in_door == LevelMap.ENTITY_TYPE.OBJECT: return false
	return true
