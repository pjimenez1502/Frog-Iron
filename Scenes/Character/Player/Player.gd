extends Character
class_name Player

func _ready() -> void:
	super._ready()
	character_stats.HEALTH_UPDATE.connect(player_update_hp)
	character_stats.DEAD.connect(player_death)

func move() -> void:
	var input_dir: Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * character_stats.SPEED
		velocity.z = direction.z * character_stats.SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, character_stats.SPEED)
		velocity.z = move_toward(velocity.z, 0, character_stats.SPEED)
	
	super.move()

func player_update_hp(max_hp: int, current_hp:int) -> void:
	SignalBus.UpdatePlayerHP.emit(max_hp, current_hp)

func player_death() -> void:
	SignalBus.PlayerDead.emit()
