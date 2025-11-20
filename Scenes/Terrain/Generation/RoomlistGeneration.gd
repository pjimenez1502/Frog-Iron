extends Node
class_name RoomListGen

var gen_settings: Dictionary = {
	"ROOM_TRIES": 10, ## times room is tried to be placed before skipping to next
	"ROOM_MIN_RAD": 1, ## MIN and MAX room size on each axis
	"ROOM_MAX_RAD": 3,
	#"BIAS": 5 ## 0 to 10, how much of the room square should be filled
	
}
var RNG : RandomNumberGenerator = RandomNumberGenerator.new()
var map: Array
var room_centers: Array

func generate_list(parameters: Dictionary) -> Array:
	RNG.seed = hash(parameters["SEED"])
	init_map(parameters)
	place_rooms(parameters)
	print_room_list(parameters)
	return map

func init_map(parameters: Dictionary) -> void:
	for row: int in parameters["SIZE"].y:
		map.append([])
		for col: int in parameters["SIZE"].x:
			map[row].append(0)

func place_rooms(parameters:Dictionary) -> void:
	var prev_pos: Vector2i = Vector2i(RNG.randi_range(2,parameters["SIZE"].x-2), RNG.randi_range(2,parameters["SIZE"].y-2))
	var current_room: int = 1
	
	generate_room(get_room_tiles(prev_pos, Vector2i(1,1)), current_room) ## SPAWN ROOM
	room_centers.append(prev_pos)
	
	for room_count: int in parameters["TARGET_ROOM_COUNT"]-1:
		var room_radius = Vector2i(RNG.randi_range(gen_settings["ROOM_MIN_RAD"],gen_settings["ROOM_MAX_RAD"]), RNG.randi_range(gen_settings["ROOM_MIN_RAD"],gen_settings["ROOM_MAX_RAD"]))
		for try: int in gen_settings["ROOM_TRIES"]:
			var room_pos: Vector2i = random_map_pos(parameters)
			if check_room_legal(parameters, room_pos, room_radius):
				var room_tiles: Array = get_room_tiles(room_pos, room_radius)
				current_room += 1
				generate_room(room_tiles, current_room)
				break

func generate_room(room_tiles: Array, room_id: int) -> void:
	print("Placing room: %d" % room_id)
	for tile: Vector2i in room_tiles:
		map[tile.x][tile.y] = room_id




## CHECK
func check_room_legal(parameters: Dictionary, room_pos: Vector2i, room_radius: Vector2i) -> bool:
	for tile: Vector2i in get_room_tiles(room_pos, room_radius): ## CHECK OUT OF BOUNDS TILES
		if tile.x < 0 or tile.x > parameters["SIZE"].x-1 or tile.y < 0 or tile.y > parameters["SIZE"].x-1:
			return false
	for tile: Vector2i in get_room_tiles(room_pos, room_radius + Vector2i(1,1)): ## CHECK OCCUPIED OR TOUCHING TILES
		if tile.x < 0 or tile.x > parameters["SIZE"].x-1 or tile.y < 0 or tile.y > parameters["SIZE"].x-1:
			continue
		if map[tile.x][tile.y] != 0: 
			return false
	return true

## UTIL
func get_room_tiles(center:Vector2i, room_radius:Vector2i) -> Array:
	var room_tiles: Array = []
	var target_tile: Vector2i
	
	for y: int in room_radius.y * 2 + 1:
		for x: int in room_radius.x * 2 + 1:
			target_tile = center + Vector2i(x-room_radius.x, y-room_radius.y)
			room_tiles.append(target_tile)
	return room_tiles

func random_map_pos(parameters: Dictionary) -> Vector2i:
	return Vector2i(RNG.randi_range(2,parameters["SIZE"].x-2), RNG.randi_range(2,parameters["SIZE"].y-2))

func print_room_list(parameters: Dictionary) -> void:
	for row: int in parameters["SIZE"].y:
		var line: String = ""
		for col: int in parameters["SIZE"].x:
			match map[row][col]:
				0:
					line += ("[color=black][%2d][/color]" % map[row][col])
				1:
					line += ("[color=green][%2d][/color]" % map[row][col])
				-1:
					line += ("[color=red][%2d][/color]" % map[row][col])
				_:
					line += ("[%2d]" % map[row][col])
		print_rich(line)
