extends Node
class_name RoomPopulator

@export var verbose: bool

@export var player_scene: PackedScene

@onready var MAP: LevelMap = %MAP
@onready var OBJECT: Node3D = %OBJECT

var RNG: RandomNumberGenerator

func populate(room_list: Array, room_centers: Array, parameters: Dictionary, _rng: RandomNumberGenerator) -> void:
	RNG = _rng
	for room_id: int  in parameters["TARGET_ROOM_COUNT"]:
		pass
	
	place_doors(room_list)
	place_treasure(room_list, parameters)
	
	place_player(room_centers[0])
	
	#Util.print_room_list(room_list, parameters)

## DOORS
func place_doors(room_list: Array) -> void:
	## loop through all corridors and check if the have a room tile adjacent and is surrounded by wall in the other axis.
	## randomize between normal, locked and barred doors
	for x: int in room_list.size():
		for y: int in room_list[0].size():
			if room_list[x][y] == -1:
				check_door_placement(room_list, Vector2i(x, y))
	if verbose:
		print("RoomPopulation: Place Doors Finished")

func check_door_placement(room_list: Array, pos: Vector2i) -> void:
	if (room_list[pos.x+1][pos.y] != 0 and room_list[pos.x+1][pos.y] != -1) or (room_list[pos.x-1][pos.y] != 0 and room_list[pos.x-1][pos.y] != -1):
		if room_list[pos.x][pos.y-1] == 0 and room_list[pos.x][pos.y+1] == 0:
			place_door(pos, deg_to_rad(90))
			room_list[pos.x][pos.y] = Util.TILE_CODES.DOOR
			return
	
	if (room_list[pos.x][pos.y+1] != 0 and room_list[pos.x][pos.y+1] != -1) or (room_list[pos.x][pos.y-1] != 0 and room_list[pos.x][pos.y-1] != -1):
		if room_list[pos.x-1][pos.y] == 0 and room_list[pos.x+1][pos.y] == 0:
			place_door(pos, deg_to_rad(0))
			return

const WOODEN_DOOR = preload("uid://dbrvim0p68m4k")
func place_door(pos: Vector2i, rotation: float) -> void:
	## TODO: CHANCE TO PLACE DIFFERENT TYPE OF DOORS
	var wooden_door: InteractableObject = WOODEN_DOOR.instantiate()
	MAP.add_to_tile(wooden_door, pos)
	#OBJECT.add_child(wooden_door)
	wooden_door.global_position = MAP.grid_to_globalpos(Vector3i(pos.x, 0, pos.y))
	wooden_door.rotate_y(rotation)


## LOOT
func place_treasure(room_list: Array, params: Dictionary) -> void:
	var total_treasure: int = 0
	for room_id: int  in range(2, params["TARGET_ROOM_COUNT"]):
		var treasure_count_weight: Array = [2,8,1]
		var room_treasure_target: int = RNG.rand_weighted(treasure_count_weight)
		var rand_find_tries: int = 0
		var placed_treasure: int = 0
		var treasure_tries: int = 0
		while placed_treasure < room_treasure_target and treasure_tries < 16 and rand_find_tries < 200:
			var pos: Vector2i = Vector2i(RNG.randi_range(0, params["SIZE"].x-1), RNG.randi_range(0, params["SIZE"].y-1))
			if room_list[pos.x][pos.y] == room_id:
				if check_chest_position(room_list, pos):
					place_chest(pos)
					room_list[pos.x][pos.y] = Util.TILE_CODES.CHEST
					placed_treasure += 1
					total_treasure += 1
				else:
					treasure_tries += 1
			else:
				rand_find_tries += 1
		if verbose:
			print("   - Placing Treasure: room: %d, placed: %d, tries: %d" % [room_id, placed_treasure, rand_find_tries])
	if verbose:
		print(" - Placed %d Treasure" % total_treasure)
		print("RoomPopulation: Place Treasure Finished")

func check_chest_position(room_list:Array, pos: Vector2i) -> bool:
	if pos.x == room_list.size()-1 or pos.y == room_list[0].size()-1 or pos.x == 0 or pos.y == 0:
		return false
	if room_list[pos.x+1][pos.y] < 0 or room_list[pos.x-1][pos.y] < 0 or room_list[pos.x][pos.y+1] < 0 or room_list[pos.x][pos.y-1] < 0:
		return false
	return true

const CHEST = preload("uid://dmgk0o744xmbo")
func place_chest(pos: Vector2i) -> void:
	var chest: Chest = CHEST.instantiate()
	MAP.add_to_tile(chest, pos)
	#OBJECT.add_child(chest)
	chest.global_position = MAP.grid_to_globalpos(Vector3i(pos.x, 0, pos.y))



func place_player(spawn_pos: Vector2i) -> void:
	var player:Player = player_scene.instantiate()
	MAP.add_child(player)
	player.character_grid_movement.set_at_grid_position(Vector3i(spawn_pos.x, 0, spawn_pos.y))
	player.character_grid_movement.move.call_deferred(Vector2i(0,1)) ## DO LATER SO ANIMATION IS VISIBLE
	if verbose:
		print("RoomPopulation: Place Player Finished")
