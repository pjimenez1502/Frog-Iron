extends Node

enum CollisionLayer {Terrain = 0b1, Player = 0b10, Enemy = 0b100}

func first_closer(origin:Vector3, a: Vector3, b:Vector3) -> bool:
	return origin.distance_squared_to(a) <= origin.distance_squared_to(b)

func worldpos_to_screenpos(origin: Vector3) -> Vector2:
	return GameDirector.current_camera.unproject_position(origin)

func get_mouse_direction(origin: Node3D) -> Vector3:
	return ((get_mouse_pos(origin) - origin.global_position) * Vector3(1,0,1)).normalized()

func get_mouse_pos(origin: Node3D) -> Vector3:
	var camera: Camera3D = origin.get_viewport().get_camera_3d()
	var position2D: Vector2 = origin.get_viewport().get_mouse_position()
	var dropPlane: Plane  = Plane(Vector3(0, 1, 0), 1)
	var position3D: Vector3 = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
	if !position3D:
		return Vector3.ZERO
	return position3D

func round_direction(direction: Vector3) -> Vector2:
	var _round_direction: Vector2 = (Vector2(1,0) if abs(direction.x) > abs(direction.z) else Vector2(0,1)) * Vector2(sign(direction.x), sign(direction.z))
	#print(abs(direction.x), " - ", abs(direction.z))
	#print("Direction: ", round_direction)
	return _round_direction



## ROOM LIST PRINT
enum TILE_CODES {
		CORRIDOR=-1, 
		ENTRANCE=-2, 
		EXIT=-3, 
		DOOR=-4, 
		CHEST=-5, 
		ENEMY=-10
	}
func print_room_list(room_list: Array, parameters: Dictionary) -> void:
	for row: int in parameters["SIZE"].y:
		var line: String = ""
		for col: int in parameters["SIZE"].x:
			match room_list[col][row]:
				0:
					line += ("[color=black][%2d][/color]" % room_list[col][row])
				1:
					line += ("[color=green][%2d][/color]" % room_list[col][row])
				TILE_CODES.CORRIDOR:
					line += ("[color=red][  ][/color]")
				TILE_CODES.ENTRANCE:
					line += ("[color=green][IN][/color]")
				TILE_CODES.EXIT:
					line += ("[color=green][EX][/color]")
				TILE_CODES.DOOR:
					line += ("[color=blue][DD][/color]")
				TILE_CODES.CHEST:
					line += ("[color=gold][CH][/color]")
				TILE_CODES.ENEMY:
					line += ("[color=red][EN][/color]")
				_:
					line += ("[%2d]" % room_list[col][row])
		print_rich(line)
