extends Node
class_name PlayerInput

var player: Player
@onready var grid_movement: CharacterGridMovement = %GridMovement
var movement_directions: Array[Vector2i] = [Vector2(0,-1), Vector2(-1,0), Vector2(0,1), Vector2(1,0)]
var is_player_turn: bool

enum ACTIONS { NONE, MELEE, RANGED, INTERACT }
var current_action: ACTIONS = ACTIONS.NONE

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
	
	InputBus.input_RELOAD.connect(reload)
	
	InputBus.action_ACCEPT.connect(action_accept)
	InputBus.action_CANCEL.connect(action_cancel)

func movement(direction: int) -> void:
	if !is_player_turn: return
	grid_movement.action(get_direction_vector(direction))
func wait() -> void:
	if !is_player_turn: return
	grid_movement.wait()


func interact() -> void:
	if !is_player_turn: return
	set_interact_aim()

func melee() -> void:
	if !is_player_turn: return
	set_melee_aim()

func ranged() -> void:
	if !is_player_turn: return
	set_ranged_aim()

func reload() -> void:
	if !is_player_turn: return
	grid_movement.reload()

func clear_aim() -> void:
	current_action = ACTIONS.NONE
	SignalBus.CursorUpdate.emit(Cursor.CURSOR.DEFAULT)
func set_melee_aim() -> void:
	current_action = ACTIONS.MELEE
	SignalBus.CursorUpdate.emit(Cursor.CURSOR.MELEE)
func set_ranged_aim() -> void:
	current_action = ACTIONS.RANGED
	SignalBus.CursorUpdate.emit(Cursor.CURSOR.RANGED)
func set_interact_aim() -> void:
	current_action = ACTIONS.INTERACT
	SignalBus.CursorUpdate.emit(Cursor.CURSOR.INTERACT)

func action_accept() -> void:
	match current_action:
		ACTIONS.NONE:
			return
		ACTIONS.MELEE:
			grid_movement.attack(Util.round_direction(Util.get_mouse_direction(grid_movement)))
		ACTIONS.RANGED:
			grid_movement.ranged_attack(Util.get_mouse_direction(grid_movement))
		ACTIONS.INTERACT:
			grid_movement.interact(Util.round_direction(Util.get_mouse_direction(grid_movement)))
	clear_aim()

func action_cancel() -> void:
	clear_aim()


var north_offset: int
func update_camera_rotation(_rotation: int) -> void:
	north_offset = _rotation

func get_direction_vector(direction: int) -> Vector2i:
	return movement_directions[(direction + north_offset)%4]

func set_player_turn(value: bool) -> void:
	is_player_turn = value
