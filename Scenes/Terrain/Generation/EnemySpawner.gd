extends Node
class_name EnemySpawner

var RNG: RandomNumberGenerator

func spawn_enemies(room_list: Array, parameters: Dictionary, _rng: RandomNumberGenerator) -> void:
	RNG = _rng
	var budget: int = Global.ENEMY_BUDGET_BASE * parameters["LEVEL"]
	
