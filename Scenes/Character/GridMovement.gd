extends Node3D
class_name CharacterGridMovement

signal FinishedMovement
var character: Character
@onready var raycasts: Dictionary[String, RayCast3D] = {"NORTH": $North, "SOUTH": $Shouth, "WEST": $West, "EAST": $East}

const GRID_DISTANCE: int = 4
var move_tween: Tween
var in_turn_cooldown: bool

@export var movement_duration: float = 0.25

func _ready() -> void:
	SignalBus.TurnFinished.connect(turn_finished)

func setup(_character: Character) -> void:
	character = _character

func action(direction: Vector2) -> void:
	in_turn_cooldown = true
	var collided: Object
	match direction:
		Vector2(0,-1):
			collided = raycasts["NORTH"].get_collider()
		Vector2(0,1):
			collided = raycasts["SOUTH"].get_collider()
		Vector2(-1,0):
			collided = raycasts["WEST"].get_collider()
		Vector2(1,0):
			collided = raycasts["EAST"].get_collider()
	
	
	
	if !collided:
		move(direction)
	if collided is Enemy:
		attack(collided)
	if collided is InteractableObject:
		interact(collided)
	if collided is GridMap:
		print("WALL")
		SignalBus.TurnFinished.emit()

func move(direction: Vector2) -> void:
	var target_position = get_parent().global_position + (Vector3(direction.x, 0, direction.y) * GRID_DISTANCE)
	move_tween = get_tree().create_tween()
	await move_tween.tween_property(character, "global_position", target_position, movement_duration).finished
	SignalBus.TurnFinished.emit()

func attack(target: Character) -> void:
	print("Attacking: %s" % target)
	SignalBus.TurnFinished.emit()

func interact(target: InteractableObject) -> void:
	print("Interacting: %s" % target)
	SignalBus.TurnFinished.emit()



func turn_finished() -> void:
	in_turn_cooldown = false

func _input(event: InputEvent) -> void:
	if in_turn_cooldown:
		return
	if event.is_action_pressed("UP"):
		action(Vector2(0,-1))
	if event.is_action_pressed("DOWN"):
		action(Vector2(0,1))
	if event.is_action_pressed("LEFT"):
		action(Vector2(-1,0))
	if event.is_action_pressed("RIGHT"):
		action(Vector2(1,0))
