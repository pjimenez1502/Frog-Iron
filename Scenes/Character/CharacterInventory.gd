extends Node
class_name CharacterInventory

var character: Character

var inventory: Array[InventorySlot]
var equipment: Dictionary[String, EquipmentSlot] = {
	"WEAPON_1": null,
	"WEAPON_2": null,
	"HEAD": null,
	"TORSO": null,
	"LEGS": null,
	"BOOTS": null,
	"BACKPACK": null}

func setup(_character: Character) -> void:
	character = _character
	init_inventory(6)
	init_equipment()

func init_inventory(inv_size: int) -> void:
	for i: int in inv_size:
		var inv_slot: InventorySlot = InventorySlot.new()
		inv_slot.slot = i
		inventory.append(inv_slot)

func init_equipment() -> void:
	equipment["WEAPON_1"] = EquipmentSlot.new().init_slot("WEAPON_1")
	equipment["WEAPON_2"] = EquipmentSlot.new().init_slot("WEAPON_2")
	equipment["HEAD"] = EquipmentSlot.new().init_slot("HEAD")
	equipment["TORSO"] = EquipmentSlot.new().init_slot("TORSO")
	equipment["LEGS"] = EquipmentSlot.new().init_slot("LEGS")
	equipment["BOOTS"] = EquipmentSlot.new().init_slot("BOOTS")
	equipment["BACKPACK"] = EquipmentSlot.new().init_slot("BACKPACK")
	#print(equipment)



#func use_item(item_slot: int) -> void:
	#var item_data: ItemResource = inventory[item_slot].item_data
	#if !item_data:
		#return
	#
	#if item_data is ConsumableResource:
		#consume_item(item_slot)
	#if item_data is EquipableResource:
		#equip_item(item_slot)

func add_item(item_data: ItemResource) -> bool:
	for inv_slot: InventorySlot in inventory: ## Try to place item in already matching slot
		if inv_slot.item_data == item_data:
			if !inv_slot.quantity < item_data.stack_size:
				continue
			inv_slot.quantity += 1
			return true
	
	for inv_slot: InventorySlot in inventory: ## Find new slot
		if inv_slot.item_data && !inv_slot.item_data == item_data: ## Slot used and doesnt match
			continue
		if !inv_slot.item_data: ## Slot empty
			inv_slot.item_data = item_data
			inv_slot.quantity = 1
			return true
	return false

func drop_item(item_slot: InventorySlot) -> bool:
	return false

func equip_item(item_slot: InventorySlot) -> void:
	var item_data: ItemResource = item_slot.item_data
	
	match item_data.equip_slot:
		Global.EquipSlot.WEAPON:
			if !equipment["WEAPON_1"].item_data:
				equipment["WEAPON_1"].item_data = item_data
				character.character_attack.weapon_1_data = item_data
				remove_item(item_slot)
			elif !equipment["WEAPON_2"].item_data:
				equipment["WEAPON_2"].item_data = item_data
				character.character_attack.weapon_2_data = item_data
				remove_item(item_slot)
			else:
				replace_equipment(item_slot, "WEAPON_1")
			character.character_attack.setup_weapons()
			return
		Global.EquipSlot.HEAD:
			if !equipment["HEAD"].item_data:
				equipment["HEAD"].item_data = item_data
				remove_item(item_slot)
				return
			replace_equipment(item_slot, "HEAD")
		Global.EquipSlot.TORSO:
			if !equipment["TORSO"].item_data:
				equipment["TORSO"].item_data = item_data
				remove_item(item_slot)
				return
			replace_equipment(item_slot, "TORSO")
		Global.EquipSlot.LEGS:
			if !equipment["LEGS"].item_data:
				equipment["LEGS"].item_data = item_data
				remove_item(item_slot)
				return
			replace_equipment(item_slot, "LEGS")
		Global.EquipSlot.BOOTS:
			if !equipment["BOOTS"].item_data:
				equipment["BOOTS"].item_data = item_data
				remove_item(item_slot)
				return
			replace_equipment(item_slot, "BOOTS")

func unequip_item(item_slot: EquipmentSlot) -> void:
	var slot_key: String = item_slot.slot_key
	if add_item(equipment[slot_key].item_data):
		equipment[slot_key].item_data = null
	
	if slot_key == "WEAPON_1":
		character.character_attack.weapon_1_data = null
		character.character_attack.setup_weapons()
	if slot_key == "WEAPON_2":
		character.character_attack.weapon_2_data = null
		character.character_attack.setup_weapons()

func consume_item(item_slot: InventorySlot) -> bool:
	inventory[item_slot].item_data.consumable_effect(character)
	remove_item(item_slot)
	return true



func replace_equipment(item_slot: InventorySlot, slot: String) -> void:
	var replaced_item: ItemResource = equipment[slot].item_data
	equipment[slot].item_data = item_slot.item_data
	
	if slot == "WEAPON_1":
		character.character_attack.weapon_1_data = item_slot.item_data
	if slot == "WEAPON_2":
		character.character_attack.weapon_2_data = item_slot.item_data
	
	remove_item(item_slot)
	add_item(replaced_item)

func remove_item(item_slot: InventorySlot) -> void:
	item_slot.quantity -= 1
	if item_slot.quantity == 0:
		item_slot.item_data = null



class InventorySlot:
	var slot: int
	var item_data: ItemResource
	var quantity: int

class EquipmentSlot:
	extends InventorySlot
	var slot_key: String
	var locked: bool = false
	
	func init_slot(key: String) -> EquipmentSlot:
		slot_key = key
		return self



## AMMO #########################################
func get_ammo(ammo_type: GunResource.AMMO_TYPES = GunResource.AMMO_TYPES.LIGHT, quantity: int = 0) -> int:
	var found: int = 0
	
	for inv_slot: InventorySlot in inventory:
		if inv_slot.item_data is AmmoResource and inv_slot.item_data.ammo_type == ammo_type:
			var found_in_slot: int = clamp(inv_slot.quantity, 0, quantity - found)
			inv_slot.quantity -= found_in_slot
			found += found_in_slot
		if found == quantity:
			return found
	return found

#var pouch_count: int = 0
#var ammo_inventory: Array[AmmoPouch]
#
#func init_ammo_inventory(pouches: int) -> void:
	#pouch_count = pouches
	#for i: int in pouch_count:
		#add_pouch()
#
#func add_pouch(ammo_type: GunResource.AMMO_TYPES = GunResource.AMMO_TYPES.LIGHT, quantity: int = 0) -> void:
	#var new_pouch: AmmoPouch = AmmoPouch.new().init_pouch(ammo_type, quantity)
	#ammo_inventory.append(new_pouch)
#
#func get_pouches_of_type(ammo_type: GunResource.AMMO_TYPES) -> Array[AmmoPouch]:
	#var pouches: Array[AmmoPouch]
	#for ammopouch: AmmoPouch in ammo_inventory:
		#if ammopouch.type == ammo_type:
			#pouches.append(ammopouch)
	#return pouches
#
#func add_ammo(ammo_type: GunResource.AMMO_TYPES = GunResource.AMMO_TYPES.LIGHT, quantity: int = 0) -> int:
	#var leftover: int = quantity
	### Finds correct pouch
	#for pouch: AmmoPouch in ammo_inventory:
		#if pouch.type == ammo_type:
			#leftover = pouch.add_to_pouch(leftover)
			#return leftover
	#
	### Find any empty pouch
	#for pouch: AmmoPouch in ammo_inventory:
		#if pouch.content == 0:
			#pouch.type = ammo_type
			#leftover = pouch.add_to_pouch(leftover)
			#return leftover
	#return leftover
#
#func get_ammo(ammo_type: GunResource.AMMO_TYPES = GunResource.AMMO_TYPES.LIGHT, quantity: int = 0) -> int:
	#var found: int
	#
	#for pouch: AmmoPouch in ammo_inventory:
		#if pouch.type == ammo_type:
			#found = pouch.get_from_pouch(quantity)
			#if found == quantity: return found
	#return found
#
#class AmmoPouch:
	#var type: GunResource.AMMO_TYPES
	#var capacity: int = 32
	#var content: int
	#
	#func init_pouch(ammo_type: GunResource.AMMO_TYPES, quantity: int) -> AmmoPouch:
		#type = ammo_type
		#content = quantity
		#return self
	#
	#func add_to_pouch(quantity: int) -> int:
		#var leftover: int = 0
		#content += quantity
		#if content > capacity: leftover = content - capacity
		#content -= leftover
		#return leftover
	#
	#func get_from_pouch(quantity: int) -> int:
		#var value: int = clamp(quantity, 0, content)
		#content -= value
		#return value
	#
	#func look_at_pouch() -> Dictionary:
		#return {"content": content, "capacity": capacity, "type": type}
