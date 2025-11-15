extends Node
class_name PlayerInventory

@onready var player: Player = $".."

var coin: int = 0
@export var inventory: Array[ItemResource]
var equipment: Dictionary = {
	"MELEE_WEAPON": null,
	"RANGED_WEAPON": null,
	"HEAD": null,
	"TORSO": null,
	"ARMS": null,
	"LEGS": null,
}

func _ready() -> void:
	SignalBus.AddPlayerCoin.connect(add_coin)
	SignalBus.PlayerCoinUpdate.emit(coin)
	SignalBus.AddPlayerItem.connect(add_item)
	SignalBus.PlayerInventoryUpdate.emit(inventory)
	
	SignalBus.ItemUsed.connect(use_item)

## COIN
func add_coin(value: int) -> void:
	coin += value
	SignalBus.PlayerCoinUpdate.emit(coin)

func pay_with_coin(value: int) -> bool:
	if coin >= value:
		add_coin(-value)
		return true
	return false

## ITEM
func add_item(item_data: ItemResource) -> void:
	#print("Received Item: %s" % item_data.name)
	inventory.append(item_data)
	SignalBus.PlayerInventoryUpdate.emit(inventory)

func use_item(item_data: ItemResource) -> void:
	if item_data is ConsumableResource:
		consume_item(item_data)
	if item_data is EquipableResource:
		equip_item(item_data)

func consume_item(item_data: ConsumableResource) -> void:
	item_data.consumable_effect(get_parent())
	inventory.erase(item_data)
	SignalBus.PlayerInventoryUpdate.emit(inventory)

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

func check_already_equipped(item_data: EquipableResource) -> bool:
	for slot_key in equipment.keys():
		if !equipment[slot_key]:
			continue
		if equipment[slot_key] == item_data:
			return true
	return false
