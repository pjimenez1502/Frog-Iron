extends Node
class_name CharacterInventory

var equipment: Dictionary[String, EquipableResource] = {
	"MELEE_WEAPON": null,
	"RANGED_WEAPON": null,
	"HEAD": null,
	"TORSO": null,
	"ARMS": null,
	"LEGS": null,
}

var ammo: Dictionary [GunResource.AMMO_TYPES, int] = {
	GunResource.AMMO_TYPES.LIGHT: 0,
	GunResource.AMMO_TYPES.HEAVY: 0,
	GunResource.AMMO_TYPES.SLUG: 0,
}

func update_ammo(type: GunResource.AMMO_TYPES, value: int) -> void:
	ammo[type] += value
