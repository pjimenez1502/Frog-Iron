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
	GunResource.AMMO_TYPES.LIGHT: 20,
	GunResource.AMMO_TYPES.HEAVY: 10,
	GunResource.AMMO_TYPES.SLUG: 8
}
