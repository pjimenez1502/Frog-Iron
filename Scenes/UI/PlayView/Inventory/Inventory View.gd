extends Control

const INVENTORT_ITEM_ENTRY = preload("uid://ttylk70icqys")

@onready var coin_value: RichTextLabel = %"Coin Value"
@onready var inventory_content: VBoxContainer = %Inventory_content

@onready var weapon_slot: VBoxContainer = %Weapon
@onready var head_slot: FoldableContainer = %Head
@onready var torso_slot: FoldableContainer = %Torso
@onready var arms_slot: FoldableContainer = %Arms
@onready var legs_slot: FoldableContainer = %Legs

func _ready() -> void:
	SignalBus.PlayerCoinUpdate.connect(update_coin)
	SignalBus.PlayerInventoryUpdate.connect(update_inventory)
	SignalBus.PlayerEquipmentUpdate.connect(update_equipment)

func update_inventory(inventory: Array[ItemResource]) -> void:
	clear_inventory()
	for item: ItemResource in inventory:
		var inventory_entry: ItemDataEntry = INVENTORT_ITEM_ENTRY.instantiate()
		inventory_content.add_child(inventory_entry)
		inventory_entry.populate(item)
		inventory_entry.button.pressed.connect(use_item.bind(inventory_entry.item_data))

func update_equipment(equipment: Dictionary) -> void:
	clear_equipment_slot(weapon_slot)
	clear_equipment_slot(head_slot)
	clear_equipment_slot(torso_slot)
	clear_equipment_slot(arms_slot)
	clear_equipment_slot(legs_slot)
	for slot_key: String in equipment.keys():
		if !equipment[slot_key]:
			continue
		var equipment_entry: ItemDataEntry = INVENTORT_ITEM_ENTRY.instantiate()
		match slot_key:
			"MELEE_WEAPON":
				weapon_slot.add_child(equipment_entry)
			"RANGED_WEAPON":
				weapon_slot.add_child(equipment_entry)
			"HEAD":
				head_slot.add_child(equipment_entry)
			"TORSO":
				torso_slot.add_child(equipment_entry)
			"ARMS":
				arms_slot.add_child(equipment_entry)
			"LEGS":
				legs_slot.add_child(equipment_entry)
		
		equipment_entry.populate(equipment[slot_key])
		equipment_entry.button.pressed.connect(use_item.bind(equipment_entry.item_data))



func use_item(item_data: ItemResource) -> void:
	SignalBus.ItemUsed.emit(item_data)

func clear_inventory() -> void:
	for entry: ItemDataEntry in inventory_content.get_children():
		entry.queue_free()
func clear_equipment_slot(slot: Container) -> void:
	for child in slot.get_children():
		child.queue_free()

func update_coin(value: int) -> void:
	coin_value.text = "%d G" % value
