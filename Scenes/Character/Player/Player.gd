extends Character
class_name Player

func _ready() -> void:
	super._ready()
	character_stats.HEALTH_UPDATE.connect(player_update_hp)
	SignalBus.AddPlayerXP.connect(update_xp)
	set_xp(0)

func move() -> void:
	var input_dir: Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * character_stats.speed
		velocity.z = direction.z * character_stats.speed
	else:
		velocity.x = move_toward(velocity.x, 0, character_stats.speed)
		velocity.z = move_toward(velocity.z, 0, character_stats.speed)
	
	super.move()

func player_update_hp(max_hp: int, current_hp:int) -> void:
	SignalBus.UpdatePlayerHP.emit(max_hp, current_hp)

func death() -> void:
	SignalBus.PlayerDead.emit()


var xp: int
func set_xp(value:int) -> void:
	xp = value
	
	SignalBus.UpdatePlayerXP.emit(xp - get_level_treshold(level-1), get_level_treshold(level))
func update_xp(value: int) -> void:
	xp += value
	check_level_up(xp)
	SignalBus.UpdatePlayerXP.emit(xp - get_level_treshold(level-1), get_level_treshold(level)-get_level_treshold(level-1))

func check_level_up(_xp: int) -> void:
	#print("level: %d, xp: %d, threshold: %d" % [level, xp, get_level_treshold(level)])
	if _xp >= get_level_treshold(level):
		level += 1
		print("levelup: ", level)

func get_level_treshold(_level: int) -> int:
	return _level * 10 * Global.LEVEL_GROWTH_MULT
