extends Node
class_name RoomPopulator

@onready var map: Node3D = %MAP
@export var player_scene: PackedScene

func populate(room_list: Array, room_centers: Array, parameters: Dictionary) -> void:
	for room_id in parameters["TARGET_ROOM_COUNT"]:
		pass
	
	
	place_player(room_centers[0])


func place_doors() -> void:
	## loop through all corridors and check if the have a room tile adjacent and is surrounded by wall in the other axis.
	## randomize between normal, locked and barred doors
	pass

func place_treasure() -> void:
	pass

func place_enemies() -> void:
	pass

func place_player(spawn_pos: Vector2i) -> void:
	var player:Player = player_scene.instantiate()
	map.add_child(player)
	player.character_grid_movement.set_at_grid_position(Vector3i(spawn_pos.x, 0, spawn_pos.y))
	player.character_grid_movement.move.call_deferred(Vector2i(0,1)) ## DO LATER SO ANIMATION IS VISIBLE
