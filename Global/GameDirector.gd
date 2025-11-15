extends Node

var enemy_list: Array[Enemy]
var player: Player

func set_player(_player: Player) -> void:
	player = _player
	player.character_grid_movement.TurnFinished.connect(finished_player_turn)

var level_gridmap: LevelGridMap
func set_level_gridmap(level: LevelGridMap) -> void:
	level_gridmap = level
	update_navmap()

func update_navmap() -> void:
	level_gridmap.update_AStar()

func finished_player_turn() -> void:
	print("Starting enemies turn")
	for enemy: Enemy in enemy_list:
		if !enemy:
			continue
		enemy.enemy_input.play_turn()
