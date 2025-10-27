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
@export var STR: int = 2
@export var DEX: int = 2
@export var INT: int = 2
@export var WIS: int = 2
@export var CON: int = 2

func _ready() -> void:
	invul_timer_setup()
	init_hp.call_deferred() ## let hud initialize before signal triggers. will probably not be necessary when proper initialization flows
	calc_speed()

func calc_speed() -> void:
	speed = base_speed + DEX*0.5

func init_hp() -> void:
	max_HP = base_HP + CON
	current_HP = max_HP
	HEALTH_UPDATE.emit(max_HP, current_HP)

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
