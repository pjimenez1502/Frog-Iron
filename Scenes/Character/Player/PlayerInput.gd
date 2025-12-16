extends Node
class_name PlayerInput

@onready var grid_movement: CharacterGridMovement = %GridMovement
var movement_directions: Array[Vector2i] = [Vector2(0,-1), Vector2(-1,0), Vector2(0,1), Vector2(1,0)]
var is_player_turn: bool

func _ready() -> void:
	SignalBus.UpdateCameraRotation.connect(update_camera_rotation)
	grid_movement.CharacterActed.connect(set_player_turn.bind(false))
	SignalBus.TurnEnded.connect(set_player_turn.bind(true))
	setup_input()

func setup_input() -> void:
	InputBus.input_MOVE.connect(movement)
	InputBus.input_INTERACT.connect(interact)
	InputBus.input_WAIT.connect(wait)
	InputBus.input_MELEE.connect(melee)
	InputBus.input_RANGED.connect(ranged)

func movement(direction: int) -> void:
	if !is_player_turn: return
	grid_movement.action(get_direction_vector(direction))
func interact() -> void:
	if !is_player_turn: return
	grid_movement.interact(Util.round_direction(Util.get_mouse_direction(grid_movement)))
func wait() -> void:
	if !is_player_turn: return
	grid_movement.wait()
func melee() -> void:
	if !is_player_turn: return
	grid_movement.attack(Util.round_direction(Util.get_mouse_direction(grid_movement)))
func ranged() -> void:
	if !is_player_turn: return
	grid_movement.ranged_attack(Util.get_mouse_direction(grid_movement))



var north_offset: int
func update_camera_rotation(_rotation: int) -> void:
	north_offset = _rotation

func get_direction_vector(direction: int) -> Vector2i:
	return movement_directions[(direction + north_offset)%4]

func set_player_turn(value: bool) -> void:
	is_player_turn = value
