extends Control
class_name EmergentInventoryView

const INVENTORT_ITEM_ENTRY = preload("uid://ttylk70icqys")
@onready var content: VBoxContainer = %Content

var inventory: Array[ItemResource]

func _ready() -> void:
	SignalBus.OpenEmergentInv.connect(populate_inv)
	SignalBus.CloseEmergentInv.connect(close_inv)
	close_inv()

func populate_inv(_inventory: Array[ItemResource]) -> void:
	inventory = _inventory
	show_inventory()

func show_inventory() -> void:
	clear_inventory()
	for item: ItemResource in inventory:
		var inventory_entry: ItemDataEntry = INVENTORT_ITEM_ENTRY.instantiate()
		content.add_child(inventory_entry)
		inventory_entry.populate(item)
		inventory_entry.ItemPressed.connect(grab_item)
	visible = true

func clear_inventory() -> void:
	for item: ItemDataEntry in content.get_children():
		item.queue_free()

func close_inv() -> void:
	SignalBus.UpdateEmergentInv.emit(inventory)
	inventory = []
	visible = false

func grab_item(item_data: ItemResource) -> void:
	SignalBus.AddPlayerItem.emit(item_data)
	
	inventory.erase(item_data)
	show_inventory()
