extends Node
class_name RoomListGen


var gen_settings: Dictionary = {
	"ROOM_TRIES": 10, ## times room is tried to be placed before skipping to next
	"ROOM_MIN_RAD": 1, ## MIN and MAX room size on each axis
	"ROOM_MAX_RAD": 3,
	#"BIAS": 5 ## 0 to 10, how much of the room square should be filled
	
}
var GenAstar: AStar2D = AStar2D.new()
var GenAstarDictionary: Dictionary
var RNG : RandomNumberGenerator
var map: Array
var room_centers: Array

func generate_list(parameters: Dictionary, _rng) -> Array:
	RNG = _rng
	
	init_map(parameters)
	place_rooms(parameters)
	place_corridors()
	place_entrance_exit()
	#print_room_list(parameters)
	
	return map

func init_map(parameters: Dictionary) -> void:
	var astarid: int = 0
	for row: int in parameters["SIZE"].y:
		map.append([])
		for col: int in parameters["SIZE"].x:
			map[row].append(0)
			GenAstar.add_point(astarid, Vector2i(row,col), 6)
			GenAstarDictionary[astarid] = Vector2i(row,col)
			astarid+=1
	
	
	for point_id: int in GenAstarDictionary.keys():
		for surrounding: Vector2i in get_surrounding_points(GenAstarDictionary[point_id], parameters["SIZE"]):
			if !GenAstarDictionary.find_key(surrounding):
				continue
			GenAstar.connect_points(point_id, GenAstarDictionary.find_key(surrounding))
	

func place_rooms(parameters:Dictionary) -> void:
	var prev_pos: Vector2i = Vector2i(RNG.randi_range(2,parameters["SIZE"].x-2), RNG.randi_range(2,parameters["SIZE"].y-2))
	var current_room: int = 1
	
	generate_room(get_room_tiles(prev_pos, Vector2i(1,1)), current_room) ## SPAWN ROOM
	room_centers.append(prev_pos)
	
	for room_count: int in parameters["TARGET_ROOM_COUNT"]:
		var room_radius: Vector2i = Vector2i(RNG.randi_range(gen_settings["ROOM_MIN_RAD"],gen_settings["ROOM_MAX_RAD"]), RNG.randi_range(gen_settings["ROOM_MIN_RAD"],gen_settings["ROOM_MAX_RAD"]))
		for try: int in gen_settings["ROOM_TRIES"]:
			var room_pos: Vector2i = random_map_pos(parameters)
			if check_room_legal(parameters, room_pos, room_radius):
				var room_tiles: Array = get_room_tiles(room_pos, room_radius)
				current_room += 1
				generate_room(room_tiles, current_room)
				place_weights(room_pos, room_radius)
				room_centers.append(room_pos)
				break

func generate_room(room_tiles: Array, room_id: int) -> void:
	#print("Placing room: %d" % room_id)
	for tile: Vector2i in room_tiles:
		map[tile.x][tile.y] = room_id


## CORRIDORS
var corrs_per_room: int = 1
func place_corridors() -> void:
	for center: Vector2i in room_centers:
		for i:int in corrs_per_room:
			var random_target_center: Vector2i = room_centers[RNG.randi_range(0,room_centers.size()-1)]
			var path:Array = GenAstar.get_point_path(GenAstarDictionary.find_key(center), GenAstarDictionary.find_key(random_target_center))
			for tile: Vector2i in path:
				if map[tile.x][tile.y] == 0:
					GenAstar.set_point_weight_scale(GenAstarDictionary.find_key(Vector2i(tile.x, tile.y)), 1)
					map[tile.x][tile.y] = -1

## ENTRANCE AND EXIT
func place_entrance_exit() -> void:
	map[room_centers[0].x][room_centers[0].y] = -2
	
	var exit_room: int = RNG.randi_range(1, room_centers.size())
	map[room_centers[exit_room].x][room_centers[exit_room].y] = -3

## CHECK
func check_room_legal(parameters: Dictionary, room_pos: Vector2i, room_radius: Vector2i) -> bool:
	for tile: Vector2i in get_room_tiles(room_pos, room_radius): ## CHECK OUT OF BOUNDS TILES
		if tile.x < 0 or tile.x > parameters["SIZE"].x-1 or tile.y < 0 or tile.y > parameters["SIZE"].y-1:
			return false
	for tile: Vector2i in get_room_tiles(room_pos, room_radius + Vector2i(1,1)): ## CHECK OCCUPIED OR TOUCHING TILES
		if tile.x < 0 or tile.x > parameters["SIZE"].x-1 or tile.y < 0 or tile.y > parameters["SIZE"].y-1:
			continue
		if map[tile.x][tile.y] != 0: 
			return false
	return true

func place_weights(room_pos: Vector2i, room_radius: Vector2i) -> void:
	for tile: Vector2i in get_room_tiles(room_pos, room_radius + Vector2i.ONE): ## Heavy weight around rooms to ensure walls
		if GenAstarDictionary.find_key(tile):
			GenAstar.set_point_weight_scale(GenAstarDictionary.find_key(tile), 10)
	pass

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
			match map[col][row]:
				0:
					line += ("[color=black][%2d][/color]" % map[col][row])
				1:
					line += ("[color=green][%2d][/color]" % map[col][row])
				-1:
					line += ("[color=red][%2d][/color]" % map[col][row])
				_:
					line += ("[%2d]" % map[col][row])
		print_rich(line)

func get_surrounding_points(grid_pos: Vector2i, map_size: Vector2i) -> Array:
	var surrounding: Array
	surrounding.append(grid_pos + Vector2i(-1,0))
	surrounding.append(grid_pos + Vector2i(1,0))
	surrounding.append(grid_pos + Vector2i(0,-1))
	surrounding.append(grid_pos + Vector2i(0,1))
	
	for tile:Vector2i in surrounding:
		if tile.x < 0 or tile.x > map_size.x-1 or tile.y < 0 or tile.y > map_size.y-1:
			surrounding.erase(tile)
	return surrounding
