extends Node3D
class_name CharacterGridMovement

var character: Character
@onready var raycasts: Dictionary[String, RayCast3D] = {"NORTH": $North, "SOUTH": $Shouth, "WEST": $West, "EAST": $East}

const GRID_DISTANCE: int = 4
var move_tween: Tween
var in_turn_cooldown: bool

@export var movement_duration: float = 0.25
var grid_position: Vector3

signal TurnFinished

func _ready() -> void:
	TurnFinished.connect(turn_finished)

func setup(_character: Character) -> void:
	character = _character

func set_at_position(_grid_position: Vector3) -> void:
	grid_position = _grid_position
	

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
	elif collided is Enemy:
		attack(collided)
	elif collided is InteractableObject:
		interact(collided)
	else:
		wall(collided)

func move(direction: Vector2) -> void:
	grid_position += Vector3(direction.x, 0, direction.y)
	var target_position = grid_position * GRID_DISTANCE + Vector3(2, 0, 2)
	move_tween = get_tree().create_tween()
	await move_tween.tween_property(character, "global_position", target_position, movement_duration).finished
	TurnFinished.emit()

func attack(target: Character) -> void:
	#print("Attacking: %s" % target)
	TurnFinished.emit()

func interact(target: InteractableObject) -> void:
	#print("Interacting: %s" % target)
	target.interact()
	TurnFinished.emit()

func wall(collided: Node3D) -> void:
	#print("Moving into wall: %s" % collided)
	TurnFinished.emit()

func turn_finished() -> void:
	in_turn_cooldown = false
