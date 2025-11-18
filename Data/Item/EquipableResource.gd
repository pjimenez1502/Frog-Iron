extends ItemResource
class_name EquipableResource

@export var equip_slot: Global.EquipSlot
@export var bonus_stats: Dictionary = {
	"STR": 0,
	"DEX": 0,
	"INT": 0,
	"WIS": 0,
	"CON": 0,
}
@export var bonus_stats_weights: Dictionary = {
	"STR": 0,
	"DEX": 0,
	"INT": 0,
	"WIS": 0,
	"CON": 0,
}

@export var scene: PackedScene

func on_use() -> void:
	print("Used Equipable")

func get_tooltip_content() -> String:
	var tooltip: String
	tooltip = "[color=#%s]%s[/color]" % [Global.rarity_colors[rarity].to_html() ,name]
	tooltip += "\n[color=#888]%s[/color]" % desc
	for stat in bonus_stats:
		if bonus_stats[stat] != 0:
			tooltip += "\n -%s: +%d" % [stat, bonus_stats[stat]]
	return tooltip
