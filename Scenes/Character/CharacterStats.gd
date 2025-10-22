extends Node

@export var SPEED = 5.0
@export var max_HP = 10
var current_HP

signal HEALTH_UPDATE
func damage() -> void:
	current_HP -= 1
	HEALTH_UPDATE.emit(current_HP)
	if current_HP <= 0:
		death()

signal DEAD
func death() -> void:
	DEAD.emit()
