extends Control

const INVENTORT_ITEM_ENTRY = preload("uid://ttylk70icqys")

@onready var coin_value: RichTextLabel = %"Coin Value"

@onready var bag: VBoxContainer = %Bag
@onready var backpack: VBoxContainer = %Backpack

@onready var weapon_1_slot: PanelContainer = %Weapon_1_Slot
@onready var weapon_2_slot: PanelContainer = %Weapon_2_Slot
@onready var head_slot: PanelContainer = %Head_Slot
@onready var torso_slot: PanelContainer = %Torso_Slot
@onready var legs_slot: PanelContainer = %Legs_Slot
@onready var boots_slot: PanelContainer = %Boots_Slot


func _ready() -> void:
	SignalBus.PlayerCoinUpdate.connect(update_coin)
	SignalBus.PlayerInventoryUpdate.connect(update_inventory)
	SignalBus.PlayerEquipmentUpdate.connect(update_equipment)
	#SignalBus.PlayerAmmoUpdate.connect(update_ammo)
	
	InputBus.inv_DROP.connect(drop_item)


func update_inventory(inventory: Array[CharacterInventory.InventorySlot]) -> void:
	clear_inventory()
	for inv_slot: CharacterInventory.InventorySlot in inventory:
		if !inv_slot.item_data:
			continue
		var inventory_entry: ItemDataEntry = INVENTORT_ITEM_ENTRY.instantiate()
		bag.add_child(inventory_entry)
		
		inventory_entry.populate(inv_slot)
		set_inv_actions(inv_slot.item_data)
		#inventory_entry.button.pressed.connect(use_item.bind(inv_slot)) ## fix

func update_equipment(equipment: Dictionary) -> void:
	clear_equipment()
	print_equipment(equipment)
	
	for slot_key: String in equipment.keys():
		if !equipment[slot_key] or !equipment[slot_key].item_data:
			continue
		var equipment_entry: ItemDataEntry = INVENTORT_ITEM_ENTRY.instantiate()
		match slot_key:
			"WEAPON_1":
				weapon_1_slot.add_child(equipment_entry)
			"WEAPON_2":
				weapon_2_slot.add_child(equipment_entry)
			"HEAD":
				head_slot.add_child(equipment_entry)
			"TORSO":
				torso_slot.add_child(equipment_entry)
			"LEGS":
				legs_slot.add_child(equipment_entry)
			"BOOTS":
				boots_slot.add_child(equipment_entry)
		
		set_equipped_actions(equipment[slot_key].item_data)
		equipment_entry.populate(equipment[slot_key])
		#equipment_entry.button.pressed.connect(use_item.bind(equipment_entry.item_data))

func drop_item() -> void:
	pass
	#for inv_item: ItemDataEntry in inventory_content.get_children():
		#if inv_item.hovered:
			#SignalBus.PlayerInventoryDrop.emit(inv_item.item_data)

#const AMMO_POUCH = preload("uid://cm33clyafba8d")
#@onready var ammo_container: GridContainer = %AmmoContainer
func update_ammo(ammo_data: Array) -> void:
	pass
	#for pouch: CharacterInventory.AmmoPouch in ammo_data:
		#var pouch_view : AmmoPouchView = AMMO_POUCH.instantiate()
		#ammo_container.add_child(pouch_view)
		#pouch_view.update_pouch(pouch.look_at_pouch())

func use_item(item_data: CharacterInventory.InventorySlot) -> void:
	SignalBus.ItemUsed.emit(item_data)

func clear_inventory() -> void:
	for entry: ItemDataEntry in bag.get_children():
		entry.queue_free()

func clear_equipment() -> void:
	clear_equipment_slot(weapon_1_slot)
	clear_equipment_slot(weapon_2_slot)
	clear_equipment_slot(head_slot)
	clear_equipment_slot(torso_slot)
	clear_equipment_slot(legs_slot)
	clear_equipment_slot(boots_slot)

func clear_equipment_slot(slot: Container) -> void:
	for child in slot.get_children():
		child.queue_free()

func update_coin(value: int) -> void:
	coin_value.text = "%d G" % value



func set_inv_actions(item: ItemResource) -> void:
	if item is EquipableResource:
		item.actions = [ItemResource.ITEMACTIONS.EQUIP, ItemResource.ITEMACTIONS.DROP]
		return
	if item is ConsumableResource:
		item.actions = [ItemResource.ITEMACTIONS.CONSUME, ItemResource.ITEMACTIONS.DROP]
		return
	item.actions = [ItemResource.ITEMACTIONS.DROP]

func set_equipped_actions(item: ItemResource) -> void:
	item.actions = [ItemResource.ITEMACTIONS.UNEQUIP, ItemResource.ITEMACTIONS.DROP]


func print_equipment(equipment: Dictionary) -> void:
	for slot_key: String in equipment.keys():
		if equipment[slot_key].item_data:
			print(slot_key, " - ", equipment[slot_key].item_data)
