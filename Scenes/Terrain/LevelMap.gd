extends Node3D
class_name LevelMap

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

func generate_walkablemap_from_room_map(room_list: Array) -> void:
	for x: int in room_list.size():
		for y: int in room_list[0].size():
			if room_list[x][y] != 0:
				walkable_tiles.append(Vector3i(x, 0, y))



func set_room_list(room_list: Array) -> void:
	generate_walkablemap_from_room_map(room_list)
	update_AStar()


#func globalpos_to_grid(pos: Vector3) -> Vector3i:
	#return local_to_map(to_local(pos))

func grid_to_globalpos(grid_pos: Vector3i) -> Vector3:
	return Vector3(grid_pos.x * Global.TILE_SIZE, 0, grid_pos.z * Global.TILE_SIZE)
