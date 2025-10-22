class_name CharacterStats
extends Node

@export var SPEED = 5.0
@export var max_HP = 10
var current_HP

func _ready() -> void:
	current_HP = max_HP

signal HEALTH_UPDATE
func damage(damage: int) -> void:
	print(damage)
	current_HP -= damage
	HEALTH_UPDATE.emit(current_HP)
	if current_HP <= 0:
		death()

signal DEAD
func death() -> void:
	DEAD.emit()
