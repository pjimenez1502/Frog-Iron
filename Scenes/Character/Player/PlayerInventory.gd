extends Node
class_name PlayerInventory

var coin: int = 0
var inventory : Array[ItemResource]

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
	pass

@onready var player_melee: PlayerMeleeWeapon = %PlayerMelee
@onready var player_ranged: PlayerRangedWeapon = %PlayerRanged

func equip_weapon() -> void:
	pass
