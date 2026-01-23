extends VBoxContainer
class_name ItemActionTooltip

@onready var take_button: Button = %Take
@onready var drop_button: Button = %Drop
@onready var equip_button: Button = %Equip
@onready var unequip_button: Button = %Unequip
@onready var consume_button: Button = %Consume

var slot_data: CharacterInventory.InventorySlot

func _ready() -> void:
	connect_button_signals()

func setup_actions(actions: Array[ItemResource.ITEMACTIONS], _slot_data: CharacterInventory.InventorySlot) -> void:
	slot_data = _slot_data
	show_actions(actions)


func take() -> void:
	SignalBus.ItemTake.emit(slot_data.item_data)

func drop() -> void:
	SignalBus.ItemDrop.emit(slot_data.item_data)

func equip() -> void:
	SignalBus.ItemEquip.emit(slot_data)

func unequip() -> void:
	SignalBus.ItemUnequip.emit(slot_data)

func consume() -> void:
	SignalBus.ItemConsume.emit(slot_data)


## SETUP
func show_actions(actions: Array[ItemResource.ITEMACTIONS]) -> void:
	take_button.visible = actions.has(ItemResource.ITEMACTIONS.TAKE)
	drop_button.visible = actions.has(ItemResource.ITEMACTIONS.DROP)
	equip_button.visible = actions.has(ItemResource.ITEMACTIONS.EQUIP)
	unequip_button.visible = actions.has(ItemResource.ITEMACTIONS.UNEQUIP)
	consume_button.visible = actions.has(ItemResource.ITEMACTIONS.CONSUME)

func connect_button_signals() -> void:
	take_button.pressed.connect(take)
	drop_button.pressed.connect(drop)
	equip_button.pressed.connect(equip)
	unequip_button.pressed.connect(unequip)
	consume_button.pressed.connect(consume)
