extends Control

@onready var weapon_1: PanelContainer = %Weapon_1
@onready var weapon_2: PanelContainer = %Weapon_2

@onready var weapon_1_name: RichTextLabel = %Weapon_1_Name
@onready var weapon_1_ammo: RichTextLabel = %Weapon_1_Ammo
@onready var weapon_2_name: RichTextLabel = %Weapon_2_Name
@onready var weapon_2_ammo: RichTextLabel = %Weapon_2_Ammo

var stowed_position: Vector2 = Vector2(64, 100)
var stowed_scale: float = 0.8

func _ready() -> void:
	SignalBus.PlayerWeaponUpdate.connect(update_weapons)

func update_weapons(weapon_1_data: Dictionary, weapon_2_data: Dictionary, selected_weapon: String) -> void:
	weapon_1_name.text = weapon_1_data["name"]
	if weapon_1_data["type"] == "MELEE":
		weapon_1_ammo.text = "∞"
	elif weapon_1_data["type"] == "RANGED":
		weapon_1_ammo.text = "%d/%d (%d)" % [weapon_1_data["current_mag"], weapon_1_data["max_mag"], weapon_1_data["ammocount"]]
	
	weapon_2_name.text = weapon_2_data["name"]
	if weapon_2_data["type"] == "MELEE":
		weapon_2_ammo.text = "∞"
	elif weapon_2_data["type"] == "RANGED":
		weapon_2_ammo.text = "%d/%d (%d)" % [weapon_2_data["current_mag"], weapon_2_data["max_mag"], weapon_2_data["ammocount"]]
	switch_selected(selected_weapon)

var selected: String = "WEAPON_1"
func switch_selected(selected_weapon: String) -> void:
	if selected_weapon == selected: return
	selected = selected_weapon
	var weapon_tween: Tween = get_tree().create_tween()
	match selected_weapon:
		"WEAPON_1":
			weapon_tween.set_parallel(true)
			weapon_tween.tween_property(weapon_1, "position", Vector2.ZERO, .25)
			weapon_tween.tween_property(weapon_2, "position", stowed_position, .25)
			weapon_tween.tween_property(weapon_1, "scale", Vector2.ONE, .25)
			weapon_tween.tween_property(weapon_2, "scale", Vector2.ONE * 0.8, .25)
		"WEAPON_2":
			weapon_tween.set_parallel(true)
			weapon_tween.tween_property(weapon_2, "position", Vector2.ZERO, .25)
			weapon_tween.tween_property(weapon_1, "position", stowed_position, .25)
			weapon_tween.tween_property(weapon_2, "scale", Vector2.ONE, .25)
			weapon_tween.tween_property(weapon_1, "scale", Vector2.ONE * 0.8, .25)


#"current_mag": current_magazine,
		#"max_mag":  weapon_data.weapon_stats["MAGAZINE"],
		#"ammocount": character.character_inventory.get_remaining_ammo(weapon_data.ammo_type),


#func update_weapon(weapon_data: Dictionary, slot: CharacterAttack.weapon_slot) -> void:
	#match slot:
		#CharacterAttack.weapon_slot.WEAPON_1:
			#melee.text = "[color=%s]%s : ∞" % [Global.hud_color.to_html(), weapon_data["name"]]
		#
		#CharacterAttack.weapon_slot.WEAPON_2:
			#pass
#
#func update_ranged(ranged_data: Dictionary) -> void:
	##print(ranged_data)
	### Color code gun name depending on rarity??
	#if !ranged_data["name"]:
		#ranged.text = ""
		#return
	#ranged.text = "[color=%s]%s : %d / %d [%d]" % [Global.hud_color.to_html(), ranged_data["name"], ranged_data["current_mag"], ranged_data["max_mag"], ranged_data["ammocount"]]
	#ranged.text = "[color=%s]%s : %d / %d [%d]" % [Global.hud_color.to_html(), ranged_data["name"], ranged_data["current_mag"], ranged_data["max_mag"], ranged_data["ammocount"]]
