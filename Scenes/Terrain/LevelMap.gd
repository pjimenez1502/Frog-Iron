extends Node3D
class_name LevelMap

var map_size: Vector2i
var room_list: Array

enum VISIBILITY { UNSEEN, SEEN, VISIBLE }
var tile_dictionary: Dictionary
var tile_visibility: Dictionary
var walkable_tiles: Array[Vector3i]

var AStar: Dictionary = {
	"WALKABLE": AStar3D.new(),
	"FLYABLE": AStar3D.new(),
}
var walk_points: Dictionary = {
	"WALKABLE": {},
	"FLYABLE": {},
}

func _ready() -> void:
	GameDirector.set_level_map(self)

var connection_offsets: Array[Vector3i] = [Vector3i(1, 0,0),Vector3i(-1, 0,0),Vector3i(0, 0,1),Vector3i(0, 0,-1)]
func update_AStar() -> void:
	## WALKABLE
	for i: int in walkable_tiles.size(): ## Add points to Astarmap and create walkables dictionary
		AStar["WALKABLE"].add_point(i, walkable_tiles[i])
		walk_points["WALKABLE"][i] = walkable_tiles[i]
	
	for id: int in walk_points["WALKABLE"].keys(): ## Check for other walkables around each walkable and Astar connect them
		for offset: Vector3i in connection_offsets:
			var found: int = find_pointid_at_pos("WALKABLE", walk_points["WALKABLE"][id]+offset)
			if found == -1:
				continue
			AStar["WALKABLE"].connect_points(id, found)

func find_pointid_at_pos(dictionary: String, _position: Vector3i) -> int:
	for id: int in walk_points[dictionary]:
		if walk_points[dictionary][id] == _position:
			return id
	return -1

var walkable_special_tiles: Array = [-1, -4]
func generate_walkablemap_from_room_map(room_list: Array) -> void:
	for x: int in room_list.size():
		for y: int in room_list[0].size():
			if room_list[x][y] > 0 or walkable_special_tiles.has(room_list[x][y]):
				walkable_tiles.append(Vector3i(x, 0, y))
	


func set_room_list(_room_list: Array) -> void:
	room_list = _room_list
	generate_walkablemap_from_room_map(_room_list)
	update_AStar()
	
	SignalBus.MapUpdate.emit(show_map())


#func globalpos_to_grid(pos: Vector3) -> Vector3i:
	#return local_to_map(to_local(pos))

func grid_to_globalpos(grid_pos: Vector3i) -> Vector3:
	return Vector3(grid_pos.x * Global.TILE_SIZE, 0, grid_pos.z * Global.TILE_SIZE)

func show_map() -> String:
	var map_text: String
	for row: int in map_size.y:
		var line: String = ""
		for col: int in map_size.x:
			if GameDirector.player.character_grid_movement.grid_position == Vector3i(col, 0, row):
				line += ("[color=red][X][/color]")
				continue
			match room_list[col][row]:
				0:
					line += ("[color=black][ ][/color]")
				Util.TILE_CODES.ENTRANCE:
					line += ("[color=green][I][/color]")
				Util.TILE_CODES.EXIT:
					line += ("[color=green][O][/color]")
				Util.TILE_CODES.CHEST:
					line += ("[color=gold][C][/color]")
				_:
					line += ("[color=gray][ ][/color]")
		map_text += (line+"\n")
	return map_text
