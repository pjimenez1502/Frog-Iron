extends Panel
class_name ItemDataEntry

@onready var button: Button = %Button

@onready var item_name: RichTextLabel = %Name
@onready var item_icon: TextureRect = %Icon
var item_data : ItemResource

func populate(_item_data: ItemResource) -> void:
	item_data = _item_data
	item_name.text = item_data.name
	self_modulate = Global.rarity_colors[item_data.rarity]
	item_name.modulate = Global.rarity_colors[item_data.rarity]
	#item_icon.texture = item_data.icon

func show_tooltip(value: bool) -> void:
	SignalBus.ShowTooltip.emit(value, item_data.get_tooltip_content())
