extends Character
class_name Player

@onready var player_inventory: PlayerInventory = %PlayerInventory

func _ready() -> void:
	super._ready()
	character_stats.HEALTH_UPDATE.connect(player_update_hp)
	set_xp(0)
	SignalBus.AddPlayerXP.connect(update_xp)
	SignalBus.PlayerStatIncrease.connect(increase_stat)
	
	SignalBus.PlayerStatsUpdate.emit(character_stats.base_stats, character_stats.calculate_stats())
	SignalBus.AvailableStatUP.emit(available_statup)
	SignalBus.PlayerEquipmentUpdate.connect(equipment_update)

func move(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * character_stats.speed
		velocity.z = direction.z * character_stats.speed
	else:
		velocity.x = move_toward(velocity.x, 0, character_stats.speed)
		velocity.z = move_toward(velocity.z, 0, character_stats.speed)
	
	character_animation.movement_animation(Vector3(velocity.x, 0, velocity.z), direction, _delta)
	super.move(_delta)



func increase_stat(stat:String, count:int) -> void:
	if !available_statup > 0:
		return
	character_stats.increase_stat(stat, count)
	SignalBus.PlayerStatsUpdate.emit(character_stats.base_stats, character_stats.calculate_stats())
	available_statup -= 1
	SignalBus.AvailableStatUP.emit(available_statup)

func equipment_update(equipment: Dictionary) -> void:
	character_stats.update_equipment_bonus(equipment)
	SignalBus.PlayerStatsUpdate.emit(character_stats.base_stats, character_stats.calculate_stats())

func player_update_hp(max_hp: int, current_hp:int) -> void:
	SignalBus.PlayerHPUpdate.emit(max_hp, current_hp)

func death() -> void:
	SignalBus.PlayerDead.emit()


var xp: int
func set_xp(value:int) -> void:
	xp = value
	SignalBus.PlayerXPUpdate.emit(xp - get_level_treshold(level-1), get_level_treshold(level))
func update_xp(value: int) -> void:
	xp += value
	check_level_up(xp)
	SignalBus.PlayerXPUpdate.emit(xp - get_level_treshold(level-1), get_level_treshold(level)-get_level_treshold(level-1))

func check_level_up(_xp: int) -> void:
	if _xp >= get_level_treshold(level):
		level += 1
		level_up()
	
	print("level: %d, xp: %d, threshold: %d" % [level, xp, get_level_treshold(level)])

var available_statup: int
func level_up() -> void:
	#print("levelup: ", level)
	available_statup += Global.LEVEL_STATUP_REWARD
	SignalBus.AvailableStatUP.emit(available_statup)

func get_level_treshold(_level: int) -> int:
	return (_level * _level * 10 * Global.LEVEL_GROWTH_MULT)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("_debug addxp"):
		update_xp(10)
