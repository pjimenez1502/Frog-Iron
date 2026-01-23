extends Control
class_name ItemDataEntry

@onready var button: CustomRLButton = $"Button"
@onready var item_name: RichTextLabel = %Name
@onready var item_icon: TextureRect = %Icon
var hovered: bool

var icon_dictionary: Dictionary = {
	"COIN": load("res://Data/Item/_Icon/Coin.png"),
	"CONSUMABLE": load("res://Data/Item/_Icon/potion.png"),
	"MELEE": load("res://Data/Item/_Icon/melee.png"),
	"RANGED": load("res://Data/Item/_Icon/ranged.png"),
	"HEAD": load("res://Data/Item/_Icon/head.png"),
	"TORSO": load("res://Data/Item/_Icon/torso.png"),
	"LEGS": load("res://Data/Item/_Icon/legs.png"),
	"ARMS": load("res://Data/Item/_Icon/arms.png"),
}

var slot_data : CharacterInventory.InventorySlot

func populate(_slot_data: CharacterInventory.InventorySlot) -> void:
	slot_data = _slot_data
	
	item_name.text = _slot_data.item_data.name
	if slot_data.quantity > 1:
		item_name.text += " (x%d)" % _slot_data.quantity
	
	self_modulate = Global.rarity_colors[_slot_data.item_data.rarity]
	item_name.modulate = Global.rarity_colors[_slot_data.item_data.rarity]
	item_icon.texture = get_icon()
	
	button.mouse_entered.connect(mouse_enter)
	button.mouse_exited.connect(mouse_exit)
	button.MouseRight.connect(right_click)

func get_icon() -> Texture2D:
	return null
	#
	#if item_data is CoinResource:
		#return icon_dictionary["COIN"]
	#if item_data is ConsumableResource:
		#return icon_dictionary["CONSUMABLE"]
	#if item_data is EquipableResource:
		#match item_data.equip_slot:
			#Global.EquipSlot.WEAPON:
				#return icon_dictionary["RANGED"]
			#Global.EquipSlot.HEAD:
				#return icon_dictionary["HEAD"]
			#Global.EquipSlot.TORSO:
				#return icon_dictionary["TORSO"]
			#Global.EquipSlot.LEGS:
				#return icon_dictionary["LEGS"]
			#Global.EquipSlot.BOOTS:
				#return icon_dictionary["ARMS"]
	#return null

func mouse_enter() -> void:
	hovered = true
	SignalBus.TooltipAction.emit(ItemTooltip.TOOLTIP_ACTION.MOUSE_IN)
	SignalBus.ShowTooltip.emit({"DESCRIPTION": slot_data.item_data.get_tooltip_content()})

func mouse_exit() -> void:
	hovered = false
	SignalBus.TooltipAction.emit(ItemTooltip.TOOLTIP_ACTION.MOUSE_OUT)

func right_click() -> void:
	SignalBus.TooltipAction.emit(ItemTooltip.TOOLTIP_ACTION.R_CLICK)
	SignalBus.ShowTooltip.emit({"ACTIONS": slot_data.item_data.actions, "SLOT": slot_data})
