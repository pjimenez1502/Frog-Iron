extends Node3D
class_name MeleeWeapon

var character_stats: CharacterStats

@onready var hits: Node = $Hits
@export var attack_hit: PackedScene

var target_layer: Util.CollisionLayer
@export_group("Damage")
var base_damage: int = 0
@export var STR_mod: float = .5
@export var DEX_mod: float = .0
@export var INT_mod: float = .0
var knockback: int = 0


func setup(item_data: EquipableResource, _character_stats: CharacterStats) -> void:
	base_damage = item_data.weapon_stats["DAMAGE"]
	knockback = item_data.weapon_stats["KNOCKBACK"]
	character_stats = _character_stats
	set_target_layer()

func attack(direction:Vector3) -> void:
	var new_hit: MeleeWeaponHit = attack_hit.instantiate()
	hits.add_child(new_hit) 
	var calculated_stats = character_stats.calculate_stats()
	var calc_damage: int = base_damage + (STR_mod * calculated_stats["STR"]) + (DEX_mod * calculated_stats["DEX"]) + (INT_mod * calculated_stats["INT"])
	var calc_knockback: int = knockback
	
	new_hit.set_weapon_data(calc_damage, calc_knockback, target_layer)
	new_hit.global_position = global_position + direction
	new_hit.look_at(new_hit.global_position + direction, Vector3.UP)

func set_target_layer() -> void:
	match character_stats.character_tag:
		character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player
