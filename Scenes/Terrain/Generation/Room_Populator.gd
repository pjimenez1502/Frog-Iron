extends Node
class_name RoomPopulator

@onready var map: Node3D = %MAP
@export var player_scene: PackedScene

func populate(room_list: Array, room_centers: Array) -> void:
	place_player(room_centers[0])

func place_player(spawn_pos: Vector2i) -> void:
	var player:Player = player_scene.instantiate()
	map.add_child(player)
	player.character_grid_movement.set_at_grid_position(Vector3i(spawn_pos.x, 0, spawn_pos.y))
	#player.position = Vector3(spawn_pos.x, 0, spawn_pos.y) * Global.TILE_SIZE
