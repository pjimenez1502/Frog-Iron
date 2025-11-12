extends Resource
class_name ItemResource

@export var name: String
@export var desc: String
@export var rarity: Global.Rarity

func get_tooltip_content() -> String:
	var tooltip: String
	tooltip = "[color=#%s]%s[/color]" % [Global.rarity_colors[rarity].to_html() ,name]
	tooltip += "\n[color=#888]%s[/color]" % desc
	return tooltip
