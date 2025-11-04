extends Resource
class_name ItemResource

@export var name: String
@export var desc: String
@export var rarity: Global.Rarity

func get_tooltip_content() -> String:
	return "[color=#%s]%s[/color] \n%s" % [Global.rarity_colors[rarity].to_html() ,name, desc]
