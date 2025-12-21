extends Node3D
class_name CharacterGridMovement

signal CharacterActed
signal CharacterMoved

var character: Character
var grid_position: Vector2i

var move_tween: Tween

@export var verbose: bool

func _ready() -> void:
	pass

func setup(_character: Character) -> void:
	character = _character

func set_at_grid_position(_grid_position: Vector2i) -> void:
	character.global_position = GameDirector.level_map.grid_to_globalpos(_grid_position)
	grid_position = _grid_position
	CharacterMoved.emit(grid_position)

func action(direction: Vector2i) -> void:
	character.character_animation.look_towards(Vector3(direction.x, 0, direction.y))
	var entity_in_position: LevelMap.ENTITY_TYPE = GameDirector.level_map.get_entity_at_pos(grid_position + direction)
	
	match entity_in_position:
		LevelMap.ENTITY_TYPE.EMPTY:
			move(direction)
		LevelMap.ENTITY_TYPE.WALL:
			wall()
		LevelMap.ENTITY_TYPE.OBJECT:
			interact(direction)
		LevelMap.ENTITY_TYPE.PLAYER:
			if character.is_in_group("Enemy"):
				attack(direction)
			else:
				wall()
		LevelMap.ENTITY_TYPE.ENEMY:
			if character.is_in_group("Player"):
				attack(direction)
			else:
				wall()


func move(direction: Vector2i) -> void:
	GameDirector.level_map.move_entity(grid_position, grid_position+direction)
	grid_position += direction
	var target_position: Vector3 = GameDirector.level_map.grid_to_globalpos(grid_position)
	move_tween = get_tree().create_tween()
	move_tween.tween_property(character, "global_position", target_position as Vector3, Global.PLAYER_TURN_DURATION) 
	
	character.character_animation.walk(Global.PLAYER_TURN_DURATION)
	CharacterActed.emit()
	CharacterMoved.emit(grid_position)
	
	if verbose:
		print("Moved to: %s" % grid_position)

func attack(direction: Vector2i) -> void:
	character.character_attack.melee_attack(direction)
	#print("Attacking: %s" % target)
	CharacterActed.emit()

func ranged_attack(direction: Vector3) -> void:
	character.character_attack.ranged_attack(direction)
	CharacterActed.emit()

func interact(direction: Vector2i) -> void:
	var interactable: InteractableObject = GameDirector.level_map.tile_dictionary[grid_position + direction].interactable
	if !interactable:
		return
	interactable.interact()
	CharacterActed.emit()

func wait() -> void:
	SignalBus.DamageText.emit("...", self, DamageTextOverlay.TYPE.MESSAGE)
	CharacterActed.emit()

func wall() -> void:
	wait()
