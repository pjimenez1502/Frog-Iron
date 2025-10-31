extends Control

const INVENTORT_ITEM_ENTRY = preload("uid://ttylk70icqys")

@onready var coin_value: RichTextLabel = %"Coin Value"
@onready var inventory_content: VBoxContainer = %Inventory_content

func _ready() -> void:
	SignalBus.PlayerCoinUpdate.connect(update_coin)
	SignalBus.PlayerInventoryUpdate.connect(update_inventory)

func update_equipped(equipped: Dictionary) -> void:
	pass


func update_inventory(inventory: Array[ItemResource]) -> void:
	clear_inventory()
	for item: ItemResource in inventory:
		var inventory_entry: ItemDataEntry = INVENTORT_ITEM_ENTRY.instantiate()
		inventory_content.add_child(inventory_entry)
		inventory_entry.populate(item)
		inventory_entry.button.pressed.connect(use_item.bind(inventory_entry.item_data))

func use_item(item_data: ItemResource) -> void:
	SignalBus.ItemUsed.emit(item_data)

func clear_inventory() -> void:
	for entry: ItemDataEntry in inventory_content.get_children():
		entry.queue_free()

func update_coin(value: int) -> void:
	coin_value.text = "%d G" % value
