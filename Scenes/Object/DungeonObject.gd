extends Node3D
class_name DungeonObject

var tile_position: Vector2i
@export var mesh_instances: Array[MeshInstance3D]
@export var is_vision_blocker: bool
var tile: MapTile

func init_dungeon_object() -> void:
	set_vision_block()

func update_is_vision_blocker(value:bool) -> void:
	is_vision_blocker = value
	set_vision_block()
	GameDirector.request_vision_update()

func set_vision_block() -> void:
	if !tile:
		printerr("Tile not assigned to DungeonObject: ", self)
		return
	tile.blocks_vision = is_vision_blocker
