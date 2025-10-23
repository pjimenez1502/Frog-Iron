class_name CharacterStats
extends Node

@onready var status_animation_player: AnimationPlayer = $"../Status Animation Player"
@export var SPEED = 5.0
@export var max_HP = 10
var current_HP

func _ready() -> void:
	current_HP = max_HP

signal HEALTH_UPDATE
signal DAMAGED
func damage(damage: int) -> void:
	current_HP -= damage
	print(current_HP)
	if current_HP <= 0:
		death()
		return
	print("damaged")
	status_animation_player.play("Damage")
	DAMAGED.emit()
	HEALTH_UPDATE.emit(current_HP)

signal DEAD
func death() -> void:
	print("dead")
	status_animation_player.play("Death")
	DEAD.emit()
