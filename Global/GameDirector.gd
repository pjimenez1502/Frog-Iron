extends Node

var enemy_list: Array[Enemy]
var player: Player
var current_camera: Camera3D
var turn_wait_timer: Timer
var level_map: LevelMap

func _ready() -> void:
	turn_wait_timer = Timer.new()
	add_child(turn_wait_timer)

func set_player(_player: Player) -> void:
	player = _player
	player.character_grid_movement.CharacterActed.connect(after_player_action)
	SignalBus.PlayerTurn.emit(true)

func set_level_map(level: LevelMap) -> void:
	level_map = level
	update_navmap()

func update_navmap() -> void:
	level_map.update_AStar()

func after_player_action() -> void:
	SignalBus.PlayerTurn.emit(false)
	turn_wait_timer.start(0.2)
	await turn_wait_timer.timeout
	SignalBus.EnemyTurn.emit()
	
	turn_wait_timer.start(0.25)
	await turn_wait_timer.timeout
	SignalBus.PlayerTurn.emit(true)
