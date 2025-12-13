extends Node3D
class_name GeneratedDungeon

@export var verbose: bool

@onready var map: LevelMap = %MAP
@onready var room_list_gen: RoomListGen = %RoomListGen
@onready var room_builder: RoomBuilder = %RoomBuilder
@onready var room_populator: RoomPopulator = %RoomPopulator
@onready var enemy_spawner: EnemySpawner = %EnemySpawner

var RNG : RandomNumberGenerator = RandomNumberGenerator.new()
var room_list: Array

var dungeon_params: Dictionary = {
	"LEVEL": 1,
	"SIZE": Vector2(38,32),
	"TARGET_ROOM_COUNT": 16,
}

func generate_dungeon(level: int, level_seed: int) -> void:
	dungeon_params["LEVEL"] = level
	RNG.seed = level_seed
	
	room_list = room_list_gen.generate_list(dungeon_params, RNG)
	if verbose:
		print("GENERATION: Room list generated")
	room_builder.build(room_list)
	if verbose:
		print("GENERATION: Room building done")
	room_populator.populate(room_list, room_list_gen.room_centers, dungeon_params, RNG)
	if verbose:
		print("GENERATION: Room population done")
	
	map.map_size = dungeon_params["SIZE"]
	map.set_room_list(room_list)
	enemy_spawner.spawn_enemies(room_list, dungeon_params, RNG)
	if verbose:
		print("GENERATION: enemies spawned")
	
	if verbose:
		Util.print_room_list(room_list, dungeon_params)
