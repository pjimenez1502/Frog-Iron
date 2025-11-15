extends GridMap
class_name LevelGridMap

const FLOOR_ID: int = 0

var AStar: Dictionary = {
	"WALKABLE": AStar3D.new(),
	"FLYABLE": AStar3D.new(),
}
var walk_points: Dictionary = {
	"WALKABLE": {},
	"FLYABLE": {},
}


func _ready() -> void:
	GameDirector.set_level_gridmap(self)

var connection_offsets: Array[Vector3i] = [Vector3i(1, 0,0),Vector3i(-1, 0,0),Vector3i(0, 0,1),Vector3i(0, 0,-1)]
func update_AStar() -> void:
	## WALKABLE
	var walkable_tiles: Array[Vector3i] = get_floor_tile_positions()
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

func get_floor_tile_positions() -> Array[Vector3i]:
	return get_used_cells_by_item(FLOOR_ID)



func globalpos_to_grid(pos: Vector3) -> Vector3i:
	return local_to_map(to_local(pos))

func grid_to_globalpos(grid: Vector3i) -> Vector3:
	return to_global(map_to_local(grid))
