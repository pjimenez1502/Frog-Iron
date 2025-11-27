extends Node
class_name RoomBuilder

@onready var MAP: Node3D = %MAP

@export var TILE_DICTIONARY: Dictionary[String, PackedScene] = {
	"FLOOR_1": null,
	"WALL": null,
	"ENTRANCE": null,
	"EXIT": null,
}

func build(room_list: Array) -> void:
	for x: int in room_list.size():
		for y: int in room_list[0].size():
			match room_list[x][y]:
				0: ## WALL
					place_tile("WALL", Vector2i(x,y))
				-1: ## CORRIDORS
					place_tile("FLOOR_1", Vector2i(x,y))
				-2: ## ENTRANCE
					place_tile("ENTRANCE", Vector2i(x,y))
				-3: ## EXIT
					place_tile("EXIT", Vector2i(x,y))
				_:
					place_tile("FLOOR_1", Vector2i(x,y))
			
			

func place_tile(tile_id: String, pos: Vector2i) -> void:
	var tile: Node3D =TILE_DICTIONARY[tile_id].instantiate()
	MAP.add_child(tile)
	tile.position = Vector3(pos.x, 0, pos.y) * Global.TILE_SIZE
