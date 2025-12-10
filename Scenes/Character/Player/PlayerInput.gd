extends Node
class_name PlayerInput

@onready var grid_movement: CharacterGridMovement = %GridMovement
var movement_directions: Array[Vector2i] = [Vector2(0,-1), Vector2(-1,0), Vector2(0,1), Vector2(1,0)]
var is_player_turn: bool

func _ready() -> void:
	SignalBus.UpdateCameraRotation.connect(update_camera_rotation)
	grid_movement.CharacterActed.connect(set_player_turn.bind(false))
	SignalBus.TurnEnded.connect(set_player_turn.bind(true))

func _physics_process(_delta: float) -> void:
	if !is_player_turn:
		return
	if Input.is_action_pressed("UP"):
		grid_movement.action(get_direction_vector(0))
		return
	if Input.is_action_pressed("DOWN"):
		grid_movement.action(get_direction_vector(2))
		return
	if Input.is_action_pressed("LEFT"):
		grid_movement.action(get_direction_vector(1))
		return
	if Input.is_action_pressed("RIGHT"):
		grid_movement.action(get_direction_vector(3))
		return

func _input(event: InputEvent) -> void:
	if !is_player_turn:
		return
	if event.is_action_pressed("UP"):
		grid_movement.action(get_direction_vector(0))
	if event.is_action_pressed("DOWN"):
		grid_movement.action(get_direction_vector(2))
	if event.is_action_pressed("LEFT"):
		grid_movement.action(get_direction_vector(1))
	if event.is_action_pressed("RIGHT"):
		grid_movement.action(get_direction_vector(3))
	
	if event.is_action_pressed("INTERACT"):## Action in mouse dir
		grid_movement.action(Util.round_direction(Util.get_mouse_direction(grid_movement)))
	if event.is_action_pressed("WAIT"):
		grid_movement.wait()
	
	if event.is_action_pressed("MELEE"):
		grid_movement.attack(Util.round_direction(Util.get_mouse_direction(grid_movement)))
	if event.is_action_pressed("RANGED"):
		grid_movement.ranged_attack(Util.get_mouse_direction(grid_movement))
	

var north_offset: int
func update_camera_rotation(_rotation: int) -> void:
	north_offset = _rotation

func get_direction_vector(direction: int) -> Vector2i:
	return movement_directions[(direction + north_offset)%4]

func set_player_turn(value: bool) -> void:
	is_player_turn = value
