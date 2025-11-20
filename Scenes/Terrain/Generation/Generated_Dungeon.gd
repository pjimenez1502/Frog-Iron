extends Node3D
class_name GeneratedDungeon

@onready var map: Node3D = %MAP
@onready var room_list_gen: RoomListGen = %RoomListGen

var room_list: Array

var dungeon_params: Dictionary = {
	"LEVEL": 1,
	"SIZE": Vector2(40,40),
	"TARGET_ROOM_COUNT": 20,
	"SEED": "test",
}

func generate_dungeon(level: int) -> void:
	dungeon_params["LEVEL"] = level
	room_list = room_list_gen.generate_list(dungeon_params)
	pass
