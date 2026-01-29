@abstract
extends Node3D
class_name Weapon

var character: Character
var target_layer: Util.CollisionLayer

var weapon_data: WeaponResource
var equipped_slot: CharacterAttack.weapon_slot

func setup(_weapon_data: WeaponResource, _character: Character, slot: CharacterAttack.weapon_slot) -> void:
	weapon_data = _weapon_data
	character = _character
	equipped_slot = slot
	
	#update_weapon_status()
	set_target_layer()

@abstract func get_status_data() -> Dictionary

func set_target_layer() -> void:
	match character.character_stats.character_tag:
		character.character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character.character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player
