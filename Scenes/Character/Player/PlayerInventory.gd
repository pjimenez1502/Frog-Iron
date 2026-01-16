extends CharacterInventory
class_name PlayerInventory

@onready var player: Player = $".."

var coin: int = 0
@export var inventory: Array[ItemResource]
@export var starting_equipment: Array[ItemResource]


func _ready() -> void:
	SignalBus.AddPlayerCoin.connect(add_coin)
	SignalBus.PlayerCoinUpdate.emit(coin)
	SignalBus.AddPlayerItem.connect(add_item)
	SignalBus.ItemUsed.connect(use_item)
	SignalBus.PlayerInventoryDrop.connect(drop_from_inventory)
	equip_starting_equipment.call_deferred()

## COIN
func add_coin(value: int) -> void:
	coin += value
	SignalBus.PlayerCoinUpdate.emit(coin)

func pay_with_coin(value: int) -> bool:
	if coin >= value:
		add_coin(-value)
		return true
	return false

# AMMO
func get_remaining_ammo(ammo_type: GunResource.AMMO_TYPES) -> int:
	return ammo[ammo_type]

## ITEM
func add_item(item_data: ItemResource) -> void:
	#print("Received Item: %s" % item_data.name)
	inventory.append(item_data)
	update_inventory_call()

func use_item(item_data: ItemResource) -> void:
	if item_data is ConsumableResource:
		consume_item(item_data)
	if item_data is EquipableResource:
		equip_item(item_data)

func consume_item(item_data: ConsumableResource) -> void:
	item_data.consumable_effect(get_parent())
	inventory.erase(item_data)
	update_inventory_call()

## EQUIPMENT
func equip_item(item_data: EquipableResource) -> void:
	if item_data.equip_slot == Global.EquipSlot.MELEEWEAPON:
		if check_already_equipped(item_data):
			unequip_melee_weapon(item_data)
			return
		equip_melee_weapon(item_data)
	elif item_data.equip_slot == Global.EquipSlot.RANGEDWEAPON:
		if check_already_equipped(item_data):
			unequip_ranged_weapon(item_data)
			return
		equip_ranged_weapon(item_data)
	else:
		if check_already_equipped(item_data):
			unequip_armor(item_data)
			return
		equip_armor(item_data)


func equip_melee_weapon(item_data: EquipableResource) -> void:
	if equipment["MELEE_WEAPON"]:
		unequip_melee_weapon(equipment["MELEE_WEAPON"])
	
	player.character_attack.melee_weapon_data = item_data
	player.character_attack.setup_weapons()
	equipment["MELEE_WEAPON"] = item_data
	inventory.erase(item_data)
	update_inventory_call()

func unequip_melee_weapon(item_data: EquipableResource) -> void:
	player.character_attack.melee_weapon_data = null
	player.character_attack.setup_weapons()
	equipment["MELEE_WEAPON"] = null
	inventory.append(item_data)
	update_inventory_call()

func equip_ranged_weapon(item_data: EquipableResource) -> void:
	if equipment["RANGED_WEAPON"]:
		unequip_ranged_weapon(equipment["RANGED_WEAPON"])
	
	player.character_attack.ranged_weapon_data = item_data
	player.character_attack.setup_weapons()
	equipment["RANGED_WEAPON"] = item_data
	inventory.erase(item_data)
	update_inventory_call()

func unequip_ranged_weapon(item_data: EquipableResource) -> void:
	player.character_attack.ranged_weapon_data = null
	player.character_attack.setup_weapons()
	equipment["RANGED_WEAPON"] = null
	inventory.append(item_data)
	update_inventory_call()

func update_inventory_call() -> void:
	SignalBus.PlayerInventoryUpdate.emit(inventory)
	SignalBus.PlayerEquipmentUpdate.emit(equipment)

func drop_from_inventory(item_data: ItemResource) -> void:
	if GameDirector.drop_item_bundle(item_data, player.character_grid_movement.grid_position):
		inventory.erase(item_data)
		SignalBus.PlayerInventoryUpdate.emit(inventory)

func equip_armor(item_data: EquipableResource) -> void:
	var slotname: String
	match item_data.equip_slot:
		Global.EquipSlot.HEAD:
			slotname = "HEAD"
		Global.EquipSlot.TORSO:
			slotname = "TORSO"
		Global.EquipSlot.ARMS:
			slotname = "ARMS"
		Global.EquipSlot.LEGS:
			slotname = "LEGS"
	
	if equipment[slotname]:
		unequip_armor(equipment[slotname])
	equipment[slotname] = item_data
	
	inventory.erase(item_data)
	update_inventory_call()

func unequip_armor(item_data: EquipableResource) -> void:
	var slotname: String
	match item_data.equip_slot:
		Global.EquipSlot.HEAD:
			slotname = "HEAD"
		Global.EquipSlot.TORSO:
			slotname = "TORSO"
		Global.EquipSlot.ARMS:
			slotname = "ARMS"
		Global.EquipSlot.LEGS:
			slotname = "LEGS"
	equipment[slotname] = null
	
	inventory.append(item_data)
	update_inventory_call()

func check_already_equipped(item_data: EquipableResource) -> bool:
	for slot_key: String in equipment.keys():
		if !equipment[slot_key]:
			continue
		if equipment[slot_key] == item_data:
			return true
	return false

func update_ammo(type: GunResource.AMMO_TYPES, value: int) -> void:
	super.update_ammo(type, value)
	update_ammo_call()
func update_ammo_call() -> void:
	SignalBus.PlayerAmmoUpdate.emit(ammo)

func equip_starting_equipment() -> void:
	for item: EquipableResource in starting_equipment:
		equip_item(item)
	
	ammo = {
		GunResource.AMMO_TYPES.LIGHT: 20,
		GunResource.AMMO_TYPES.HEAVY: 10,
		GunResource.AMMO_TYPES.SLUG: 8
	}
	
	update_inventory_call()
	update_ammo_call()
