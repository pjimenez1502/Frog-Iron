extends Node3D
class_name Chest

@export var locked: bool
@export var inventory : Array[ItemResource]

func update_inventory(_inventory: Array[ItemResource]) -> void:
	inventory = _inventory
