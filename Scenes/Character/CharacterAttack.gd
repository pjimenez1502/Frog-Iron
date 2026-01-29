extends Node
class_name CharacterAttack

const UNARMED = preload("uid://bdntcukq7he2r")
@onready var character: Character = $".."

@export var weapon_attatchment: WeaponAttachment
enum weapon_slot { WEAPON_1, WEAPON_2 }
var equipped: weapon_slot = weapon_slot.WEAPON_1

@export var weapon_1_data: WeaponResource
@export var weapon_2_data: WeaponResource
var weapon_1: Weapon
var weapon_2: Weapon


func _ready() -> void:
	setup_weapons.call_deferred()

func setup_weapons() -> void:
	if weapon_1:
		weapon_1.queue_free()
	if weapon_2:
		weapon_2.queue_free()
	
	if weapon_1_data:
		var new_weapon_1: Weapon = weapon_1_data.scene.instantiate()
		weapon_attatchment.add_child(new_weapon_1)
		weapon_1 = new_weapon_1
		weapon_1.setup(weapon_1_data, character, weapon_slot.WEAPON_1)
	else:
		weapon_1_data = UNARMED
		setup_weapons()
	
	if weapon_2_data:
		var new_weapon_2: Weapon = weapon_2_data.scene.instantiate()
		weapon_attatchment.add_child(new_weapon_2)
		weapon_2 = new_weapon_2
		weapon_2.setup(weapon_2_data, character, weapon_slot.WEAPON_1)
	else:
		weapon_2_data = UNARMED
		setup_weapons()
	
	send_hud_update_if_player()


func attack(direction:Vector2) -> void:
	var equipped_weapon: Weapon = weapon_1 if equipped == weapon_slot.WEAPON_1 else weapon_2
	if equipped_weapon.weapon_data.stamina_cost > character.character_stats.current_stamina:
		SignalBus.DamageText.emit("Too Exhausted!", character, DamageTextOverlay.TYPE.MESSAGE, DamageTextOverlay.SIZE.SMALL)
		return
	equipped_weapon.attack(direction)
	character.character_stats.change_stamina(-equipped_weapon.weapon_data.stamina_cost)
	send_hud_update_if_player()


func reload() -> bool:
	var equipped_weapon: Weapon = weapon_1 if equipped == weapon_slot.WEAPON_1 else weapon_2
	var equipped_weapon_data: WeaponResource = weapon_1_data if equipped == weapon_slot.WEAPON_1 else weapon_2_data
	
	if equipped_weapon is MeleeWeapon:
		return false
	
	var remaining_in_magazine: int = equipped_weapon.current_magazine
	if remaining_in_magazine >= equipped_weapon.weapon_data.weapon_stats["MAGAZINE"]:
		SignalBus.DamageText.emit("Magazine already full!", character, DamageTextOverlay.TYPE.MESSAGE, DamageTextOverlay.SIZE.SMALL)
		return false
	
	var reload_count: int = character.character_inventory.get_ammo(equipped_weapon_data.ammo_type, equipped_weapon_data.weapon_stats["MAGAZINE"] - remaining_in_magazine)
	if reload_count == 0:
		SignalBus.DamageText.emit("No Ammo!", character, DamageTextOverlay.TYPE.MESSAGE, DamageTextOverlay.SIZE.SMALL)
		return false
		
	SignalBus.DamageText.emit("Reload!", character, DamageTextOverlay.TYPE.MESSAGE, DamageTextOverlay.SIZE.SMALL)
	await get_tree().create_timer(0.25).timeout
	
	equipped_weapon.current_magazine = remaining_in_magazine + reload_count
	send_hud_update_if_player()
	return true

func send_hud_update_if_player() -> void:
	if character is Player:
		#print(weapon_1_data)
		SignalBus.PlayerWeaponUpdate.emit(weapon_1.get_status_data(), weapon_2.get_status_data(), equipped)

func weapon_switch() -> void:
	print("SWITCH WEAPONS")
	pass
