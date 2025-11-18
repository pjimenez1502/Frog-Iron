extends Character
class_name Dummy

func _ready() -> void:
	character_stats = null

func move(_delta: float) -> void:
	pass

func damage(_damage: int, _hitchance: int) -> void:
	var calc_damage: int = calc_hit_camage(_damage, _hitchance)
	
	if calc_damage > 0:
		SignalBus.DamageText.emit(str(calc_damage), self, DamageTextOverlay.TYPE.DAMAGE)
	else:
		SignalBus.DamageText.emit("MISS", self, DamageTextOverlay.TYPE.MESSAGE)

func calc_hit_camage(damage: int, hitchance: int) -> int:
	var finished: bool
	var final_damage: int = 0
	var curr_hitchance: int = hitchance
	while(!finished):
		if curr_hitchance >= 100:
			final_damage += damage
			curr_hitchance -= 100
		else:
			var rand: int = randi_range(1,100)
			print(curr_hitchance, " - ", rand)
			if curr_hitchance > rand:
				final_damage += damage
			finished = true
	return final_damage
