extends Control

@onready var melee: RichTextLabel = %Melee
@onready var ranged: RichTextLabel = %Ranged

func _ready() -> void:
	SignalBus.PlayerWeaponRangedUpdate.connect(update_ranged)

func update_melee(melee_data: Dictionary) -> void:
	melee.text = "[color=%s]%s : ∞" % [Global.hud_color.to_html(), melee_data["name"]]

func update_ranged(ranged_data: Dictionary) -> void:
	print(ranged_data)
	ranged.text = "[color=%s]%s : %d / %d [%d]" % [Global.hud_color.to_html(), ranged_data["name"], ranged_data["current_mag"], ranged_data["max_mag"], ranged_data["ammocount"]]
	ranged.text = "[color=%s]%s : %d / %d [%d]" % [Global.hud_color.to_html(), ranged_data["name"], ranged_data["current_mag"], ranged_data["max_mag"], ranged_data["ammocount"]]
