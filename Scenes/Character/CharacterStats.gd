extends Node
class_name CharacterStats

signal HEALTH_UPDATE
signal STAMINA_UPDATE
signal SANITY_UPDATE
signal DAMAGED
signal DEAD

enum CHAR_TAG {ENEMY, PLAYER}
@export var character_tag : CHAR_TAG

#@export var base_speed: int = 5
#var speed: float
@export var base_HP: int = 4
var max_HP: int
var current_HP: int

@export var base_stamina: int = 8
var max_stamina: int
var current_stamina: int

@export var base_sanity: int = 10
var max_sanity: int
var current_sanity: int

@export_category("CharStats")
@export var base_stats: Dictionary = {
	"STR": 2,
	"DEX": 2,
	"INT": 2,
	"WIS": 2,
	"CON": 2,
}
var bonus_stats: Dictionary = {
	"STR": 0,
	"DEX": 0,
	"INT": 0,
	"WIS": 0,
	"CON": 0,
}
var calculated_stats : Dictionary

func _ready() -> void:
	calculate_stats()
	init_stats.call_deferred()## let hud initialize before signal triggers. will probably not be necessary when proper initialization flows
	#calculate_speed()

func init_stats() -> void:
	init_hp()
	init_stamina()
	init_sanity()

func increase_stat(stat: String, count: int) -> void:
	match stat:
		"STR":
			base_stats["STR"] += count
		"DEX":
			base_stats["DEX"] += count
		"INT":
			base_stats["INT"] += count
		"WIS":
			base_stats["WIS"] += count
		"CON":
			base_stats["CON"] += count

func update_equipment_bonus(equipment: Dictionary) -> void:
	bonus_stats = { "STR": 0, "DEX": 0, "INT": 0, "WIS": 0, "CON": 0 }
	for slot: String in equipment:
		if !equipment[slot]:
			continue
		for stat: String in equipment[slot].bonus_stats:
			bonus_stats[stat] += equipment[slot].bonus_stats[stat]

func calculate_stats() -> Dictionary:
	calculated_stats = {
		"STR": base_stats["STR"] + bonus_stats["STR"],
		"DEX": base_stats["DEX"] + bonus_stats["DEX"],
		"INT": base_stats["INT"] + bonus_stats["INT"],
		"WIS": base_stats["WIS"] + bonus_stats["WIS"],
		"CON": base_stats["CON"] + bonus_stats["CON"],
	}
	recalculate_stats()
	return calculated_stats

func recalculate_stats() -> void:
	calculate_hp()
	calculate_stamina()
	calculate_sanity()
	#calculate_speed()

#func calculate_speed() -> void:
	#speed = base_speed + calculated_stats["DEX"] * 0.5

## HP
func init_hp() -> void:
	max_HP = base_HP + calculated_stats["CON"] * Global.con_health_mult
	current_HP = max_HP
	HEALTH_UPDATE.emit(max_HP, current_HP)

func calculate_hp() -> void:
	var prev_max_hp: int = max_HP
	max_HP = base_HP + calculated_stats["CON"] * Global.con_health_mult
	current_HP = roundi(float(current_HP) / float(prev_max_hp)  * max_HP)
	HEALTH_UPDATE.emit(max_HP, current_HP)

func heal(_value: int) -> void:
	current_HP = clampi(current_HP + _value, 0, max_HP)
	HEALTH_UPDATE.emit(max_HP, current_HP)
	SignalBus.DamageText.emit(str(_value), get_parent(), DamageTextOverlay.TYPE.HEAL)

func damage(_damage: int, _hitchance: int) -> void:
	current_HP -= calc_hit_camage(_damage, _hitchance)
	HEALTH_UPDATE.emit(max_HP, current_HP)
	if _damage > 0:
		SignalBus.DamageText.emit(str(_damage), get_parent(), DamageTextOverlay.TYPE.DAMAGE)
	else:
		SignalBus.DamageText.emit("MISS", get_parent(), DamageTextOverlay.TYPE.MESSAGE)
	
	if current_HP <= 0:
		defeat(DEFEAT_TYPE.HEALTH)
		return
	DAMAGED.emit()


## STAMINA
func init_stamina() -> void:
	max_stamina = base_stamina + calculated_stats["DEX"] * Global.dex_stamina_mult
	current_stamina = max_stamina
	STAMINA_UPDATE.emit(max_stamina, current_stamina)
	SignalBus.TurnEnded.connect(stamina_regen)

func calculate_stamina() -> void:
	var prev_max_stamina: int = max_stamina
	max_stamina = base_stamina + calculated_stats["DEX"] * Global.dex_stamina_mult
	current_stamina = roundi(float(current_stamina) / float(prev_max_stamina) * max_stamina)
	STAMINA_UPDATE.emit(max_stamina, current_stamina)

func change_stamina(_value: int) -> void:
	current_stamina = clampi(current_stamina + _value, 0, max_stamina)
	STAMINA_UPDATE.emit(max_stamina, current_stamina)

var stamina_regen_turns: int = 4
var stamina_regen_counter: int = 0
func stamina_regen() -> void:
	stamina_regen_counter += 1
	if stamina_regen_counter >= stamina_regen_turns:
		stamina_regen_counter = 0
		change_stamina(1)

## SANITY
func init_sanity() -> void:
	max_sanity = base_sanity + calculated_stats["WIS"] * Global.wis_sanity_mult
	current_sanity = max_sanity
	SANITY_UPDATE.emit(max_sanity, current_sanity)

func calculate_sanity() -> void:
	var prev_max_sanity: int = max_sanity
	max_sanity = base_sanity + calculated_stats["WIS"] * Global.wis_sanity_mult
	current_sanity = roundi(float(current_sanity) / float(prev_max_sanity)  * max_sanity)
	SANITY_UPDATE.emit(max_sanity, current_sanity)

func change_sanity(_value: int) -> void:
	current_sanity = clampi(current_sanity + _value, 0, max_sanity)
	SANITY_UPDATE.emit(max_sanity, current_sanity)
	if current_sanity == 0:
		defeat(DEFEAT_TYPE.SANITY)



enum DEFEAT_TYPE { HEALTH, SANITY }
func defeat(defeat_reason: DEFEAT_TYPE) -> void:
	match defeat_reason:
		DEFEAT_TYPE.HEALTH:
			DEAD.emit()
		DEFEAT_TYPE.SANITY:
			print("defeated sanity")



func calc_hit_camage(_damage: int, hitchance: int) -> int:
	var finished: bool
	var final_damage: int = 0
	var curr_hitchance: int = hitchance
	while(!finished):
		if curr_hitchance >= 100:
			final_damage += _damage
			curr_hitchance -= 100
		else:
			var rand: int = randi_range(1,50) + calculated_stats["DEX"]
			#print(curr_hitchance, " - ", rand)
			if curr_hitchance > rand:
				final_damage += _damage
			finished = true
	return final_damage
