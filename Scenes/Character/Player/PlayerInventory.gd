extends Node
class_name PlayerInventory

@onready var character_stats: CharacterStats = %CharacterStats

var coin: int = 0
var inventory: Array[ItemResource]
var equipment: Dictionary = {
	"WEAPON": null,
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
	if item_data.equip_slot == Global.EquipSlot.RANGEDWEAPON or item_data.equip_slot == Global.EquipSlot.MELEEWEAPON:
		if check_already_equipped(item_data):
			unequip_weapon(item_data)
			return
		equip_weapon(item_data)
	else:
		if check_already_equipped(item_data):
			unequip_armor(item_data)
			return
		equip_armor(item_data)


@onready var player_melee: PlayerMeleeWeapon = %PlayerMelee
@onready var player_ranged: PlayerRangedWeapon = %PlayerRanged

func equip_weapon(item_data: EquipableResource) -> void:
	if equipment["WEAPON"]:
		unequip_weapon(equipment["WEAPON"])
	
	var weapon: Node3D
	match item_data.equip_slot:
		Global.EquipSlot.RANGEDWEAPON:
			weapon = item_data.scene.instantiate()
			player_ranged.add_child(weapon)
			player_ranged.enabled = true
			player_ranged.weapon = weapon
			weapon.setup(item_data, character_stats)
			
		Global.EquipSlot.MELEEWEAPON:
			weapon = item_data.scene.instantiate()
			player_melee.add_child(weapon)
			player_melee.enabled = true
			player_melee.weapon = weapon
			weapon.setup(item_data, character_stats)
	
	equipment["WEAPON"] = item_data
	inventory.erase(item_data)
	SignalBus.PlayerInventoryUpdate.emit(inventory)
	SignalBus.PlayerEquipmentUpdate.emit(equipment)

func unequip_weapon(item_data: EquipableResource) -> void:
	match item_data.equip_slot:
		Global.EquipSlot.RANGEDWEAPON:
			player_ranged.weapon.queue_free()
		Global.EquipSlot.MELEEWEAPON:
			player_melee.weapon.queue_free()
	equipment["WEAPON"] = null
	inventory.append(item_data)
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
	SignalBus.PlayerInventoryUpdate.emit(inventory)
	SignalBus.PlayerEquipmentUpdate.emit(equipment)

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
	SignalBus.PlayerInventoryUpdate.emit(inventory)
	SignalBus.PlayerEquipmentUpdate.emit(equipment)

func check_already_equipped(item_data: EquipableResource) -> bool:
	for slot_key in equipment.keys():
		if !equipment[slot_key]:
			continue
		if equipment[slot_key] == item_data:
			return true
	return false
