extends Node3D
class_name GeneratedDungeon

@onready var map: LevelMap = %MAP
@onready var room_list_gen: RoomListGen = %RoomListGen
@onready var room_builder: RoomBuilder = %RoomBuilder
@onready var room_populator: RoomPopulator = %RoomPopulator

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
	room_builder.build(room_list)
	room_populator.populate(room_list, room_list_gen.room_centers)
	
	map.set_room_list(room_list)
