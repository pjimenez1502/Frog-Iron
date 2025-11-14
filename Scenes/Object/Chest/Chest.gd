extends InteractableObject
class_name Chest

@export var random: bool
@export var inventory : Array[ItemResource]

func _ready() -> void:
	if random:
		update_inventory(LootDirector.generate_chest_loot(Global.CHEST_BUDGET))

func update_inventory(_inventory: Array[ItemResource]) -> void:
	inventory = _inventory
