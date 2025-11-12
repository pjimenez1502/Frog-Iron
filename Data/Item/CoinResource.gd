extends ItemResource
class_name CoinResource

@export var amount: int

func get_tooltip_content() -> String:
	var tooltip: String
	tooltip = "[color=#%s]%s[/color]" % [Global.rarity_colors[rarity].to_html() ,name]
	tooltip += "\n[color=#888]Contains %s coins[/color]" % amount
	return tooltip
