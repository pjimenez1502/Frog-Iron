extends EquipableResource
class_name WeaponResource

@export var weapon_stats: Dictionary = {
	"DAMAGE": 2,
	"KNOCKBACK": 0,
	"HITCHANCE": 60,
}
@export var damage_scaling: Dictionary = {
	"STR": 0.0,
	"DEX": 0.0,
	"INT": 0.0,
	"WIS": 0.0,
	"CON": 0.0,
}
@export var hitchance_scaling: Dictionary = {
	"STR": 0,
	"DEX": 0,
	"INT": 0,
	"WIS": 0,
	"CON": 0,
}

func get_tooltip_content() -> String:
	var tooltip: String
	var item_material: String = Global.rarity_prefixes[MATERIAL.keys()[material]][rarity]
	tooltip = "[color=#%s]%s %s[/color]" % [Global.rarity_colors[rarity].to_html(), item_material, name]
	tooltip += "\n[color=#888]%s[/color]" % desc
	tooltip += "\n Damage: %d" % calculate_damage(GameDirector.player.character_stats)
	tooltip += "\n Hit Chance: %d%%" % calculate_hitchance(GameDirector.player.character_stats)
	for stat: String in bonus_stats:
		if bonus_stats[stat] != 0:
			tooltip += "\n -%s: +%d" % [stat, bonus_stats[stat]]
	return tooltip

func calculate_damage(character_stats: CharacterStats) -> int:
	var calculated_stats: Dictionary = character_stats.calculate_stats()
	return (weapon_stats["DAMAGE"] + 
	(damage_scaling["STR"] * calculated_stats["STR"]) + 
	(damage_scaling["DEX"] * calculated_stats["DEX"]) + 
	(damage_scaling["INT"] * calculated_stats["INT"]) +
	(damage_scaling["WIS"] * calculated_stats["WIS"]) +
	(damage_scaling["CON"] * calculated_stats["CON"]))

func calculate_hitchance(character_stats: CharacterStats) -> int:
	var calculated_stats: Dictionary = character_stats.calculate_stats()
	return (weapon_stats["HITCHANCE"] + 
	(hitchance_scaling["STR"] * calculated_stats["STR"]) + 
	(hitchance_scaling["DEX"] * calculated_stats["DEX"]) + 
	(hitchance_scaling["INT"] * calculated_stats["INT"]) +
	(hitchance_scaling["WIS"] * calculated_stats["WIS"]) +
	(hitchance_scaling["CON"] * calculated_stats["CON"]))
