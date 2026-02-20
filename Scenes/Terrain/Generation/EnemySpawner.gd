extends Node
class_name EnemySpawner

var RNG: RandomNumberGenerator

@export var enemy_pool: Array[EnemyResource]
var enemy_weights: Array

@onready var ENEMY_CONTAINER: Node3D = %ENEMY
@onready var MAP: LevelMap = %MAP

func spawn_enemies(room_list: Array, parameters: Dictionary, _rng: RandomNumberGenerator) -> void:
	RNG = _rng
	var budget: int = Global.ENEMY_BUDGET_BASE * parameters["LEVEL"]
	
	for enemy_data in enemy_pool:
		enemy_weights.append(enemy_data.spawn_weight)
	
	while budget > 0:
		var found_pos: Vector2i = find_enemy_spawnpos(room_list, parameters)
		if found_pos == -Vector2i.ONE: ## NO FOUND POSITION
			continue
		room_list[found_pos.x][found_pos.y] = Util.TILE_CODES.ENEMY
		var enemy_data: EnemyResource = enemy_pool[_rng.rand_weighted(enemy_weights)]
		var enemy: Enemy = enemy_data.scene.instantiate()
		ENEMY_CONTAINER.add_child(enemy)
		enemy.enemy_setup(enemy_data)
		enemy.character_grid_movement.set_at_grid_position(found_pos)
		budget -= enemy.spawn_cost
		MAP.add_entity_to_entitymap(found_pos, LevelMap.ENTITY_TYPE.ENEMY)

func find_enemy_spawnpos(room_list: Array, parameters: Dictionary) -> Vector2i:
	for try: int in 10:
		var pos: Vector2i = Vector2i(RNG.randi_range(0, parameters["SIZE"].x-1), RNG.randi_range(0, parameters["SIZE"].y-1))
		if room_list[pos.x][pos.y] > 1:
			return Vector2i(pos.x, pos.y)
	return -Vector2.ONE
