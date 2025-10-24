extends Node

func first_closer(origin:Vector3, a: Vector3, b:Vector3) -> bool:
	return origin.distance_squared_to(a) <= origin.distance_squared_to(b)
