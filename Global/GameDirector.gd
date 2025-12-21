extends Node

var player: Player
var current_camera: Camera3D
var turn_wait_timer: Timer

var enemy_list: Array[Enemy]
var level_map: LevelMap
var entity_map: Dictionary


func _ready() -> void:
	turn_wait_timer = Timer.new()
	add_child(turn_wait_timer)
	SignalBus.DropItemBundle.connect(drop_item_bundle)

func set_player(_player: Player) -> void:
	player = _player
	player.character_grid_movement.CharacterActed.connect(after_player_action)
	SignalBus.TurnEnded.emit()

func set_level_map(level: LevelMap) -> void:
	level_map = level
	update_navmap()

func update_navmap() -> void:
	level_map.update_AStar()

func after_player_action() -> void:
	update_enemies_visible()
	turn_wait_timer.start(0.2)
	await turn_wait_timer.timeout
	SignalBus.EnemyTurn.emit()
	
	turn_wait_timer.start(0.25)
	await turn_wait_timer.timeout
	SignalBus.TurnEnded.emit()

func request_vision_update() -> void:
	SignalBus.UpdatePlayerVision.emit(player.character_grid_movement.grid_position)

func drop_item_bundle(item_data: ItemResource, pos: Vector2i) -> bool:
	var target_tile_interactable: InteractableObject = level_map.tile_dictionary[pos].interactable if level_map.tile_dictionary[pos].interactable else null
	var item_bundle: Chest
	if target_tile_interactable:
		if !target_tile_interactable is Chest:
			return false
		item_bundle = target_tile_interactable
	else:
		item_bundle = load("res://Scenes/Object/ItemBundle/ItemBundle.tscn").instantiate()
		level_map.add_to_tile(item_bundle, pos)
	item_bundle.inventory.append(item_data)
	SignalBus.OpenEmergentInv.emit(item_bundle.inventory)
	return true

func remove_object_from_tile(object: DungeonObject) -> void:
	object.queue_free()

func update_enemies_visible() -> void:
	for enemy: Enemy in enemy_list:
		enemy.update_is_visible()

func is_tile_visible(pos: Vector2i) -> bool:
	if level_map.tile_dictionary[pos].current_visiblity == LevelMap.VISIBILITY.VISIBLE: return true
	return false
