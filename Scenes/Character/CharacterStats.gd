extends Node
class_name CharacterStats

signal HEALTH_UPDATE
signal DAMAGED
signal DEAD

@onready var status_animation_player: AnimationPlayer = $"../Status Animation Player"
@export var SPEED = 5.0
@export var max_HP = 10
var current_HP

func _ready() -> void:
	invul_timer_setup()
	init_hp.call_deferred() ## let hud initialize before signal triggers. will probably not be necessary when proper initialization flows

func init_hp() -> void:
	current_HP = max_HP
	HEALTH_UPDATE.emit(max_HP, current_HP)

func damage(damage: int) -> void:
	if invulnerable:
		return
	current_HP -= damage
	damage_invulnerability()
	if current_HP <= 0:
		death()
		return
	status_animation_player.play("Damage")
	DAMAGED.emit()
	HEALTH_UPDATE.emit(max_HP, current_HP)

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
	invul_timer.wait_time = .4
	add_child(invul_timer)
