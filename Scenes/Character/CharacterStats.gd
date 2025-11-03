extends Node
class_name CharacterStats

signal HEALTH_UPDATE
signal DAMAGED
signal DEAD

@onready var status_animation_player: AnimationPlayer = $"../Status Animation Player"
enum CHAR_TAG {ENEMY, PLAYER}
@export var character_tag : CHAR_TAG

@export var base_speed: int = 5
var speed: float
@export var base_HP: int = 4
var max_HP: int
var current_HP: int

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
	invul_timer_setup()
	calculate_stats()
	init_hp.call_deferred() ## let hud initialize before signal triggers. will probably not be necessary when proper initialization flows
	calculate_speed()

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
	calculate_speed()

func calculate_speed() -> void:
	speed = base_speed + calculated_stats["DEX"] * 0.5

func init_hp() -> void:
	max_HP = base_HP + calculated_stats["CON"]
	current_HP = max_HP
	HEALTH_UPDATE.emit(max_HP, current_HP)

func calculate_hp() -> void:
	var prev_max_hp: int = max_HP
	
	max_HP = base_HP + calculated_stats["CON"]
	current_HP = roundi(float(current_HP) / float(prev_max_hp)  * max_HP)
	HEALTH_UPDATE.emit(max_HP, current_HP)

func heal(_value: int) -> void:
	current_HP = clamp(current_HP + _value, 0, max_HP)
	HEALTH_UPDATE.emit(max_HP, current_HP)
	print("healed: ", _value)

func damage(_damage: int) -> void:
	if invulnerable:
		return
	current_HP -= _damage
	HEALTH_UPDATE.emit(max_HP, current_HP)
	damage_invulnerability()
	
	if current_HP <= 0:
		death()
		return
	status_animation_player.play("Damage")
	DAMAGED.emit()

func death() -> void:
	status_animation_player.play("Death")
	DEAD.emit()

var invulnerable: bool
var invul_timer: Timer
func damage_invulnerability() -> void:
	invulnerable = true
	invul_timer.start()
	await invul_timer.timeout
	invulnerable = false

func invul_timer_setup() -> void:
	invul_timer = Timer.new()
	invul_timer.wait_time = Global.INVUL_DURATION
	add_child(invul_timer)
