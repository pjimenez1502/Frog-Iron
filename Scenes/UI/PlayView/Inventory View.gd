extends Control

@onready var coin_value: RichTextLabel = %"Coin Value"

func _ready() -> void:
	SignalBus.PlayerCoinUpdate.connect(update_coin)

func update_equipped(equipped: Dictionary) -> void:
	pass

func update_inventory(inventory: Dictionary) -> void:
	pass

func update_coin(value: int) -> void:
	coin_value.text = "%d G" % value
