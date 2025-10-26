extends Node3D
class_name Weapon

@onready var character_stats: CharacterStats = %CharacterStats

@onready var hits: Node = $Hits
@export var attack_hit: PackedScene

var target_layer: Util.CollisionLayer
@export_group("Damage")
@export var base_damage: int = 2
@export var STR_mod: float = .5
@export var DEX_mod: float = .0
@export var INT_mod: float = .0
@export var knockback: int = 1

func _ready() -> void:
	match character_stats.character_tag:
		character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player

func attack(direction:Vector3) -> void:
	var new_hit: WeaponHit = attack_hit.instantiate()
	hits.add_child(new_hit)
	
	var calc_damage: int = base_damage + (STR_mod * character_stats.STR) + (DEX_mod * character_stats.DEX) + (INT_mod * character_stats.INT)
	var calc_knockback: int = knockback
	
	new_hit.set_weapon_data(calc_damage, calc_knockback, target_layer)
	new_hit.global_position = global_position + direction
	new_hit.look_at(new_hit.global_position + direction, Vector3.UP)
