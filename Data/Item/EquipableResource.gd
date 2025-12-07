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
enum MATERIAL {METAL, LEATHER, CLOTH, JEWELRY}
@export var material: MATERIAL
func on_use() -> void:
	print("Used Equipable")

func get_tooltip_content() -> String:
	var tooltip: String
	var item_material: String = Global.rarity_prefixes[MATERIAL.keys()[material]][rarity]
	tooltip = "[color=#%s]%s %s[/color]" % [Global.rarity_colors[rarity].to_html(), item_material, name]
	tooltip += "\n[color=#888]%s[/color]" % desc
	for stat: String in bonus_stats:
		if bonus_stats[stat] != 0:
			tooltip += "\n -%s: +%d" % [stat, bonus_stats[stat]]
	return tooltip
