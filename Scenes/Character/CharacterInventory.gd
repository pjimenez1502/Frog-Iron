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

var pouch_count: int = 0
var ammo_inventory: Array[AmmoPouch]

func init_ammo_inventory(pouches: int) -> void:
	pouch_count = pouches
	for i: int in pouch_count:
		add_pouch()

func add_pouch(ammo_type: GunResource.AMMO_TYPES = GunResource.AMMO_TYPES.LIGHT, quantity: int = 0) -> void:
	var new_pouch: AmmoPouch = AmmoPouch.new().init_pouch(ammo_type, quantity)
	ammo_inventory.append(new_pouch)

func get_pouches_of_type(ammo_type: GunResource.AMMO_TYPES) -> Array[AmmoPouch]:
	var pouches: Array[AmmoPouch]
	for ammopouch: AmmoPouch in ammo_inventory:
		if ammopouch.type == ammo_type:
			pouches.append(ammopouch)
	return pouches

func add_ammo(ammo_type: GunResource.AMMO_TYPES = GunResource.AMMO_TYPES.LIGHT, quantity: int = 0) -> int:
	var leftover: int = quantity
	## Finds correct pouch
	for pouch: AmmoPouch in ammo_inventory:
		if pouch.type == ammo_type:
			leftover = pouch.add_to_pouch(leftover)
			return leftover
	
	## Find any empty pouch
	for pouch: AmmoPouch in ammo_inventory:
		if pouch.content == 0:
			pouch.type = ammo_type
			leftover = pouch.add_to_pouch(leftover)
			return leftover
	return leftover

func get_ammo(ammo_type: GunResource.AMMO_TYPES = GunResource.AMMO_TYPES.LIGHT, quantity: int = 0) -> int:
	var found: int
	for pouch: AmmoPouch in ammo_inventory:
		if pouch.type == ammo_type:
			found = pouch.get_from_pouch(quantity)
			if found == quantity: return found
	return found

class AmmoPouch:
	var type: GunResource.AMMO_TYPES
	var capacity: int = 32
	var content: int
	
	func init_pouch(ammo_type: GunResource.AMMO_TYPES, quantity: int) -> AmmoPouch:
		type = ammo_type
		content = quantity
		return self
	
	func add_to_pouch(quantity: int) -> int:
		var leftover: int = 0
		content += quantity
		if content > capacity: leftover = content - capacity
		content -= leftover
		return leftover
	
	func get_from_pouch(quantity: int) -> int:
		var value: int = clamp(quantity, 0, content)
		content -= value
		return value
	
	func look_at_pouch() -> Dictionary:
		return {"content": content, "capacity": capacity, "type": type}
