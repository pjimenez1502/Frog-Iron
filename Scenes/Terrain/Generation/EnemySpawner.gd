extends Node
class_name EnemySpawner

var RNG: RandomNumberGenerator
@export var enemy_pool: Array[PackedScene]

@onready var ENEMY_CONTAINER: Node3D = %ENEMY
@onready var MAP: LevelMap = %MAP

func spawn_enemies(room_list: Array, parameters: Dictionary, _rng: RandomNumberGenerator) -> void:
	RNG = _rng
	var budget: int = Global.ENEMY_BUDGET_BASE * parameters["LEVEL"]
	
	while budget > 0:
		var found_pos: Vector3i = find_enemy_spawnpos(room_list, parameters)
		if found_pos == -Vector3i.ONE: ## NO FOUND POSITION
			continue
		
		var enemy: Enemy = enemy_pool[_rng.randi_range(0, enemy_pool.size()-1)].instantiate()
		ENEMY_CONTAINER.add_child(enemy)
		enemy.global_position = MAP.grid_to_globalpos(found_pos)
		budget -= enemy.spawn_cost

func find_enemy_spawnpos(room_list: Array, parameters: Dictionary) -> Vector3i:
	for try: int in 10:
		var pos: Vector2i = Vector2i(RNG.randi_range(0, parameters["SIZE"].x-1), RNG.randi_range(0, parameters["SIZE"].x-1))
		if room_list[pos.x][pos.y] > 1:
			return Vector3i(pos.x, 0, pos.y)
	return -Vector3.ONE
