extends Node
class_name RoomBuilder

@onready var MAP: Node3D = %MAP

@export var TILE_DICTIONARY: Dictionary[String, Array] = {
	"FLOOR": [
		preload("res://Scenes/Terrain/Dungeon_1/Tiles/Floor_tile_1.tscn"),
		preload("res://Scenes/Terrain/Dungeon_1/Tiles/Floor_tile_2.tscn"),
		preload("res://Scenes/Terrain/Dungeon_1/Tiles/Floor_tile_3.tscn"),
		],
	"WALL": [preload("res://Scenes/Terrain/Dungeon_1/Tiles/Wall_tile.tscn")],
	"ENTRANCE": [preload("res://Scenes/Terrain/Dungeon_1/Tiles/Entrance_tile.tscn")],
	"EXIT": [preload("res://Scenes/Terrain/Dungeon_1/Tiles/Exit_tile.tscn")],
}

func build(room_list: Array) -> void:
	for x: int in room_list.size():
		for y: int in room_list[0].size():
			match room_list[x][y]:
				0: ## WALL
					place_tile("WALL", Vector2i(x,y))
				-1: ## CORRIDORS
					place_tile("FLOOR", Vector2i(x,y))
				-2: ## ENTRANCE
					place_tile("ENTRANCE", Vector2i(x,y))
				-3: ## EXIT
					place_tile("EXIT", Vector2i(x,y))
				_:
					place_tile("FLOOR", Vector2i(x,y))

func place_tile(tile_id: String, pos: Vector2i) -> void:
	var tile: MapTile = TILE_DICTIONARY[tile_id].pick_random().instantiate()
	MAP.tile_dictionary[pos] = tile
	MAP.tile_visibility[pos] = MAP.VISIBILITY.UNSEEN
	MAP.add_tile(tile, pos)
	tile.position = Vector3(pos.x, 0, pos.y) * Global.TILE_SIZE
