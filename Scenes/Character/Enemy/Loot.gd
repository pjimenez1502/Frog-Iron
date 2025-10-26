extends Node
class_name Loot

@export var xp: int
@export var rewards: Array

func drop_loot() -> void:
	SignalBus.AddPlayerXP.emit(xp)
