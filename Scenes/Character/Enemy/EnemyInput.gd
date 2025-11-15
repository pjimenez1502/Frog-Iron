extends Node
class_name EnemyInput

@onready var grid_movement: CharacterGridMovement = %GridMovement
@onready var collision_shape_3d: CollisionShape3D = $"../../Detection/FarDetection/CollisionShape3D"
@onready var los_raycast: RayCast3D = %LOS_Raycast

@onready var close_detection: Area3D = $"../../Detection/CloseDetection"
@onready var far_detection: Area3D = $"../../Detection/FarDetection"

var close_target: Node3D
var far_target: Node3D
var target: Node3D

func _ready() -> void:
	SignalBus.EnemyTurn.connect(play_turn)
	
	close_detection.body_entered.connect(add_close_target)
	close_detection.body_exited.connect(remove_close_target)
	far_detection.body_entered.connect(add_far_target)
	far_detection.body_exited.connect(remove_far_target)



func play_turn() -> void:
	#print("close target: %s - far target: %s - target: %s" % [close_target, far_target, target])
	if !far_target and !close_target:
		return
		
	if close_target:
		target = close_target
		move_towards_target()
		return
	if far_target and check_lineofsight():
		target = far_target
		move_towards_target()
		return



func move_towards_target() -> void:
	var origin_point: int = GameDirector.level_gridmap.find_pointid_at_pos("WALKABLE" ,GameDirector.level_gridmap.globalpos_to_grid(get_parent().global_position))
	var target_point: int = GameDirector.level_gridmap.find_pointid_at_pos("WALKABLE" ,GameDirector.level_gridmap.globalpos_to_grid(target.global_position))
	
	var next_point: Vector3i = GameDirector.level_gridmap.AStar["WALKABLE"].get_point_path(origin_point, target_point, true)[1]
	var direction = next_point - GameDirector.level_gridmap.globalpos_to_grid(get_parent().global_position)
	#print("PATHFIND = origin: %d - target: %d" % [origin_point, target_point])
	#print("POSITION: %s - NEXT: %s" % [grid_movement.grid_position, next_point])
	
	grid_movement.action(Vector2(direction.x, direction.z))

func find_target() -> Node3D:
	if far_target && check_lineofsight():
		return far_target
	if close_target:
		return close_target
	return null

func check_lineofsight() -> bool:
	los_raycast.global_position = get_parent().global_position + Vector3(0,1,0)
	los_raycast.target_position = get_parent().to_local(far_target.global_position) + Vector3(0,1,0)
	if los_raycast.is_colliding():
		return false
	return true




func add_close_target(body: Node3D) -> void:
	close_target = body
func remove_close_target(body: Node3D) -> void:
	if close_target == body:
		close_target = null

func add_far_target(body: Node3D) -> void:
	far_target = body
func remove_far_target(body: Node3D) -> void:
	if far_target == body:
		far_target = null
