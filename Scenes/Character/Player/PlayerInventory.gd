extends Node
class_name PlayerInventory

var coin: int = 0
var inventory : Array[ItemResource]

func _ready() -> void:
	SignalBus.AddPlayerCoin.connect(add_coin)
	SignalBus.PlayerCoinUpdate.emit(coin)
	SignalBus.AddPlayerItem.connect(add_item)
	SignalBus.PlayerInventoryUpdate.emit(inventory)

func add_coin(value: int) -> void:
	coin += value
	SignalBus.PlayerCoinUpdate.emit(coin)

func pay_with_coin(value: int) -> bool:
	if coin >= value:
		add_coin(-value)
		return true
	return false

func add_item(item_data: ItemResource) -> void:
	#print("Received Item: %s" % item_data.name)
	inventory.append(item_data)
	SignalBus.PlayerInventoryUpdate.emit(inventory)
