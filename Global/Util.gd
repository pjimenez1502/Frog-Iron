extends Node

enum CollisionLayers {Terrain = 0b1, Player = 0b10, Enemy = 0b100}

func first_closer(origin:Vector3, a: Vector3, b:Vector3) -> bool:
	return origin.distance_squared_to(a) <= origin.distance_squared_to(b)

func get_mouse_direction(origin: Node3D):
	return (get_mouse_pos(origin) - origin.global_position).normalized()

func get_mouse_pos(origin: Node3D):
	var camera = origin.get_viewport().get_camera_3d()
	var position2D = origin.get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 1)
	var position3D = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
	if !position3D:
		return Vector3.ZERO
	return position3D
