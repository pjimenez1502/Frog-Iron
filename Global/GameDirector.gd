extends Node

var enemy_list: Array[Enemy]
var player: Player
var turn_wait_timer: Timer
var level_gridmap: LevelGridMap

func _ready() -> void:
	turn_wait_timer = Timer.new()
	add_child(turn_wait_timer)

func set_player(_player: Player) -> void:
	player = _player
	player.character_grid_movement.CharacterActed.connect(after_player_action)
	SignalBus.PlayerTurn.emit(true)

func set_level_gridmap(level: LevelGridMap) -> void:
	level_gridmap = level
	update_navmap()

func update_navmap() -> void:
	level_gridmap.update_AStar()

func after_player_action() -> void:
	SignalBus.PlayerTurn.emit(false)
	turn_wait_timer.start(0.1)
	turn_wait_timer.start(Global.ENEMY_TURN_DURATION)
	await turn_wait_timer.timeout
	SignalBus.EnemyTurn.emit()
	
	turn_wait_timer.start(Global.PLAYER_TURN_DURATION)
	await turn_wait_timer.timeout
	SignalBus.PlayerTurn.emit(true)
