extends Node
class_name PlayerInventory

var coin: int = 0

func _ready() -> void:
	SignalBus.AddPlayerCoin.connect(add_coin)
	SignalBus.PlayerCoinUpdate.emit(coin)

func add_coin(value: int) -> void:
	coin += value
	SignalBus.PlayerCoinUpdate.emit(coin)

func pay_with_coin(value: int) -> bool:
	if coin >= value:
		add_coin(-value)
		return true
	return false
