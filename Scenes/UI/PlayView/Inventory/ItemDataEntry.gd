extends Panel
class_name ItemDataEntry

@onready var button: Button = %Button

@onready var item_name: RichTextLabel = %Name
@onready var item_icon: TextureRect = %Icon
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
var item_data : ItemResource

func populate(_item_data: ItemResource) -> void:
	print(_item_data.rarity)
	item_data = _item_data
	item_name.text = item_data.name
	self_modulate = Global.rarity_colors[item_data.rarity]
	item_name.modulate = Global.rarity_colors[item_data.rarity]
	item_icon.texture = get_icon()

func get_icon() -> Texture2D:
	if item_data is CoinResource:
		return icon_dictionary["COIN"]
	if item_data is ConsumableResource:
		return icon_dictionary["CONSUMABLE"]
	if item_data is EquipableResource:
		match item_data.equip_slot:
			Global.EquipSlot.MELEEWEAPON:
				return icon_dictionary["MELEE"]
			Global.EquipSlot.RANGEDWEAPON:
				return icon_dictionary["RANGED"]
			Global.EquipSlot.HEAD:
				return icon_dictionary["HEAD"]
			Global.EquipSlot.TORSO:
				return icon_dictionary["TORSO"]
			Global.EquipSlot.ARMS:
				return icon_dictionary["ARMS"]
			Global.EquipSlot.LEGS:
				return icon_dictionary["LEGS"]
	return null

func show_tooltip(value: bool) -> void:
	SignalBus.ShowTooltip.emit(value, item_data.get_tooltip_content())
