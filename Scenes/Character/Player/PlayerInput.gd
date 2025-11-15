extends Node
class_name PlayerInput

@onready var grid_movement: CharacterGridMovement = %GridMovement
var movement_directions: Array[Vector2i] = [Vector2(0,-1), Vector2(-1,0), Vector2(0,1), Vector2(1,0)]

func _ready() -> void:
	SignalBus.UpdateCameraRotation.connect(update_camera_rotation)

func _input(event: InputEvent) -> void:
	if grid_movement.in_turn_cooldown:
		return
	if event.is_action_pressed("UP"):
		grid_movement.action(get_direction_vector(0))
	if event.is_action_pressed("DOWN"):
		grid_movement.action(get_direction_vector(2))
	if event.is_action_pressed("LEFT"):
		grid_movement.action(get_direction_vector(1))
	if event.is_action_pressed("RIGHT"):
		grid_movement.action(get_direction_vector(3))
	if event.is_action_pressed("INTERACT"):
		grid_movement.action(Util.round_direction(Util.get_mouse_direction(grid_movement)))

var north_offset: int
func update_camera_rotation(_rotation) -> void:
	north_offset = _rotation

func get_direction_vector(direction: int) -> Vector2i:
	return movement_directions[(direction + north_offset)%4]
