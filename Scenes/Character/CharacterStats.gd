class_name CharacterStats
extends Node

@onready var status_animation_player: AnimationPlayer = $"../Status Animation Player"
@export var SPEED = 5.0
@export var max_HP = 10
var current_HP

func _ready() -> void:
	current_HP = max_HP
	invul_timer_setup()

signal HEALTH_UPDATE
signal DAMAGED
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
	HEALTH_UPDATE.emit(current_HP)

signal DEAD
func death() -> void:
	print("dead")
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
