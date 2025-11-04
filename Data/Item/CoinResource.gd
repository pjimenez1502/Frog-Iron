extends ItemResource
class_name CoinResource

@export var amount: int

func get_tooltip_content() -> String:
	return "[color=#%s]%s[/color] \n Contains %s coins." % [Global.rarity_colors[rarity].to_html() ,name, amount]
