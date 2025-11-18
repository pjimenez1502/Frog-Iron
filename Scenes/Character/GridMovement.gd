extends Node3D
class_name CharacterGridMovement

const GRID_DISTANCE: int = 4
signal CharacterActed

var character: Character
@onready var raycasts: Dictionary[String, RayCast3D] = {"NORTH": $North, "SOUTH": $Shouth, "WEST": $West, "EAST": $East}
var move_tween: Tween
var grid_position: Vector3i

func _ready() -> void:
	grid_position = GameDirector.level_gridmap.globalpos_to_grid(global_position)

func setup(_character: Character) -> void:
	character = _character

func set_at_grid_position(_grid_position: Vector3i) -> void:
	global_position = GameDirector.level_gridmap.grid_to_globalpos(grid_position)
	grid_position = _grid_position

func action(direction: Vector2i) -> void:
	var collided: Object = get_ray_by_direction(direction).get_collider()
	
	#print(character, [character.is_in_group("Player"), collided is Enemy, character.is_in_group("Enemy"), collided is Player])
	if !collided:
		move(direction)
	elif (character.is_in_group("Player") and collided.is_in_group("Enemy")) or (character.is_in_group("Enemy") and collided.is_in_group("Player")):
		attack(direction)
	elif collided is InteractableObject:
		interact(collided)
	else:
		wall(collided)

func move(direction: Vector2i) -> void:
	grid_position += Vector3i(direction.x, 0, direction.y)
	var target_position = grid_position * GRID_DISTANCE + Vector3i(2, 0, 2)
	move_tween = get_tree().create_tween()
	move_tween.tween_property(character, "global_position", target_position as Vector3, Global.PLAYER_TURN_DURATION) 
	CharacterActed.emit()

func attack(direction: Vector2i) -> void:
	character.character_attack.melee_attack(direction)
	#print("Attacking: %s" % target)
	CharacterActed.emit()

func ranged_attack(direction: Vector3) -> void:
	character.character_attack.ranged_attack(direction)
	CharacterActed.emit()

func interact(target: InteractableObject) -> void:
	#print("Interacting: %s" % target)
	target.interact()
	CharacterActed.emit()

func wall(_collided: Node3D) -> void:
	#print("Moving into wall: %s" % collided)
	CharacterActed.emit()

func get_ray_by_direction(direction: Vector2i) -> RayCast3D:
	match direction:
		Vector2i(0,-1):
			return raycasts["NORTH"]
		Vector2i(0,1):
			return raycasts["SOUTH"]
		Vector2i(-1,0):
			return raycasts["WEST"]
		Vector2i(1,0):
			return raycasts["EAST"]
	return null
