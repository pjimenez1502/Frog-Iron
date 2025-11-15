extends Node3D
class_name CharacterGridMovement

var character: Character
@onready var raycasts: Dictionary[String, RayCast3D] = {"NORTH": $North, "SOUTH": $Shouth, "WEST": $West, "EAST": $East}

const GRID_DISTANCE: int = 4
var move_tween: Tween

var grid_position: Vector3

signal CharacterActed

func _ready() -> void:
	grid_position = GameDirector.level_gridmap.globalpos_to_grid(global_position)

func setup(_character: Character) -> void:
	character = _character

func set_at_position(_grid_position: Vector3) -> void:
	grid_position = _grid_position

func action(direction: Vector2) -> void:
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
	
	#print(character, [character.is_in_group("Player"), collided is Enemy, character.is_in_group("Enemy"), collided is Player])
	if !collided:
		move(direction)
	elif (character.is_in_group("Player") and collided is Enemy) or (character.is_in_group("Enemy") and collided is Player):
		attack(collided)
	elif collided is InteractableObject:
		interact(collided)
	else:
		wall(collided)
	CharacterActed.emit()

func move(direction: Vector2) -> void:
	grid_position += Vector3(direction.x, 0, direction.y)
	var target_position = grid_position * GRID_DISTANCE + Vector3(2, 0, 2)
	move_tween = get_tree().create_tween()
	await move_tween.tween_property(character, "global_position", target_position, Global.PLAYER_TURN_DURATION).finished

func attack(target: Character) -> void:
	character.character_attack.melee_attack(target)
	print("Attacking: %s" % target)
	

func interact(target: InteractableObject) -> void:
	#print("Interacting: %s" % target)
	target.interact()

func wall(_collided: Node3D) -> void:
	#print("Moving into wall: %s" % collided)
	pass
