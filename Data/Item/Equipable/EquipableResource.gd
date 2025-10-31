extends ItemResource
class_name EquipableResource

@export var equip_slot: Global.EquipSlot
@export var bonus_stats: Dictionary = {
	"STR": 0,
	"DEX": 0,
	"INT": 0,
	"WIS": 0,
	"CON": 0,
}
@export var weapon_stats: Dictionary = {
	"DAMAGE": 2,
	"KNOCKBACK": 1,
}

@export var scene: PackedScene

func on_use() -> void:
	print("Used Equipable")
