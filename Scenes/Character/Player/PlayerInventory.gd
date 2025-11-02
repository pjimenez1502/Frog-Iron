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
	match item_data.equip_slot:
		Global.EquipSlot.RANGEDWEAPON:
			if check_already_equipped(item_data):
				unequip_ranged_weapon(item_data)
				return
			equip_ranged_weapon(item_data)
		pass


@onready var player_melee: PlayerMeleeWeapon = %PlayerMelee
@onready var player_ranged: PlayerRangedWeapon = %PlayerRanged

func equip_ranged_weapon(item_data: EquipableResource) -> void:
	var weapon: RangedWeapon = item_data.scene.instantiate()
	player_ranged.add_child(weapon)
	weapon.equipped(character_stats)
	player_ranged.enabled = true
	player_ranged.weapon = weapon
	equipment["WEAPON"] = item_data
	inventory.erase(item_data)
	SignalBus.PlayerInventoryUpdate.emit(inventory)
	SignalBus.PlayerEquipmentUpdate.emit(equipment)

func unequip_ranged_weapon(item_data: EquipableResource) -> void:
	player_ranged.weapon.queue_free()
	equipment["WEAPON"] = null
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
