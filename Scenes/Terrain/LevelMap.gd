extends Node3D
class_name LevelMap

@onready var shadow_casting: ShadowCasting = %ShadowCasting

var map_size: Vector2i
var room_list: Array

enum VISIBILITY { UNSEEN, SEEN, VISIBLE }
var tile_dictionary: Dictionary
var tile_visibility: Dictionary
var walkable_tiles: Array[Vector2i]

var entity_map: Dictionary

var AStar: Dictionary = {
	"WALKABLE": AStar2D.new(),
	"FLYABLE": AStar2D.new(),
}
var walk_points: Dictionary = {
	"WALKABLE": {},
	"FLYABLE": {},
}

func _ready() -> void:
	GameDirector.set_level_map(self)
	SignalBus.UpdatePlayerVision.connect(update_player_vision)
	SignalBus.VisionBlockUpdate.connect(update_vision_blocker)
	SignalBus.EntityMapPointUpdate.connect(set_entity_at_pos)

func set_room_list(_room_list: Array) -> void:
	room_list = _room_list
	generate_walkablemap_from_room_map()
	update_AStar()
	init_entitymap()
	shadow_casting.init_shadowcasting(tile_dictionary, map_size)

func add_tile(tile: MapTile, pos: Vector2i) -> void:
	add_child(tile)
	tile_dictionary[pos] = tile
func add_to_tile(object: DungeonObject, pos: Vector2i) -> bool:
	if object is InteractableObject:
		if tile_dictionary[pos].interactable:
			printerr("TILE ALREADY CONTAINS INTERACTABLE")
			return false
		tile_dictionary[pos].interactable = object
	
	tile_dictionary[pos].add_child(object)
	object.tile = tile_dictionary[pos]
	for object_mesh: MeshInstance3D in object.mesh_instances:
		tile_dictionary[pos].meshes.append(object_mesh)
	object.tile_position = pos
	object.init_dungeon_object()
	
	add_entity_to_entitymap(pos, ENTITY_TYPE.OBJECT)
	return true


## Pathing
var connection_offsets: Array[Vector2i] = [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]
func update_AStar() -> void:
	## WALKABLE
	for i: int in walkable_tiles.size(): ## Add points to Astarmap and create walkables dictionary
		AStar["WALKABLE"].add_point(i, walkable_tiles[i])
		walk_points["WALKABLE"][i] = walkable_tiles[i]
	
	for id: int in walk_points["WALKABLE"].keys(): ## Check for other walkables around each walkable and Astar connect them
		for offset: Vector2i in connection_offsets:
			var found: int = find_pointid_at_pos("WALKABLE", walk_points["WALKABLE"][id]+offset)
			if found == -1:
				continue
			AStar["WALKABLE"].connect_points(id, found)

func find_pointid_at_pos(dictionary: String, _position: Vector2i) -> int:
	for id: int in walk_points[dictionary]:
		if walk_points[dictionary][id] == _position:
			return id
	return -1

var walkable_special_tiles: Array = [-1, -4]
func generate_walkablemap_from_room_map() -> void:
	for x: int in room_list.size():
		for y: int in room_list[0].size():
			if room_list[x][y] > 0 or walkable_special_tiles.has(room_list[x][y]):
				walkable_tiles.append(Vector2i(x, y))


## ENTITY_MAP
enum ENTITY_TYPE { EMPTY, WALL, OBJECT, PLAYER, ENEMY }
func init_entitymap() -> void:
	for x: int in room_list.size():
		for y: int in room_list[0].size():
			if entity_map.has(Vector2i(x,y)):
				continue
			if room_list[x][y] == 0:
				entity_map[Vector2i(x,y)] = ENTITY_TYPE.WALL
				continue
			entity_map[Vector2i(x,y)] = ENTITY_TYPE.EMPTY

func set_entity_at_pos(pos: Vector2i, type: ENTITY_TYPE) -> void:
	entity_map[pos] = type

func get_entity_at_pos(pos: Vector2i) -> ENTITY_TYPE:
	if !entity_map.has(pos): return ENTITY_TYPE.EMPTY
	return entity_map[pos]

func add_entity_to_entitymap(pos: Vector2i, type: ENTITY_TYPE) -> void:
	entity_map[pos] = type

func move_entity(origin: Vector2i, destination: Vector2i) -> void:
	entity_map[destination] = entity_map[origin]
	entity_map[origin] = ENTITY_TYPE.EMPTY


func show_map(visible_tiles: Dictionary) -> String:
	var map_text: String = ""
	for row: int in map_size.y:
		var line: String = ""
		for col: int in map_size.x:
			if !visible_tiles.has(Vector2i(col,row)):
				line += ("   ")
				continue
			
			if GameDirector.player.character_grid_movement.grid_position == Vector2i(col, row):
				line += ("[color=red][X][/color]")
				continue
			match room_list[col][row]:
				0:
					line += ("[color=#222][#][/color]")
				Util.TILE_CODES.ENTRANCE:
					line += ("[color=green][I][/color]")
				Util.TILE_CODES.EXIT:
					line += ("[color=green][O][/color]")
				Util.TILE_CODES.CHEST:
					line += ("[color=gold][C][/color]")
				_:
					line += ("[color=#888][ ][/color]")
		map_text += (line+"\n")
	return map_text

## VISION
func update_player_vision(player_pos: Vector2i) -> void:
	var visible_tiles: Dictionary = shadow_casting.update_fov(player_pos)
	SignalBus.MapUpdate.emit(show_map(visible_tiles))

func update_vision_blocker(tile: Vector2i, blocks_vision: bool) -> void:
	tile_dictionary[tile].blocks_vision = blocks_vision
	update_player_vision(GameDirector.player.character_grid_movement.grid_position)
