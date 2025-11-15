extends Node3D
class_name MeleeWeapon

var character_stats: CharacterStats
var character_animation: CharacterAnimation

@onready var hits: Node = $Hits
@export var attack_hit: PackedScene

var target_layer: Util.CollisionLayer
@export_group("Damage")
var base_damage: int = 0
var damage_scaling: Dictionary
var knockback: int = 0
var attack_delay: float = 1


func setup(item_data: EquipableResource, _character_stats: CharacterStats, _character_animation: CharacterAnimation) -> void:
	base_damage = item_data.weapon_stats["DAMAGE"]
	knockback = item_data.weapon_stats["KNOCKBACK"]
	attack_delay = item_data.weapon_stats["DELAY"]
	damage_scaling = item_data.damage_scaling
	character_stats = _character_stats
	character_animation = _character_animation
	#character_animation.torso_state(item_data.torso_state)
	set_target_layer()

func attack(direction:Vector3) -> void:
	var new_hit: MeleeWeaponHit = attack_hit.instantiate()
	hits.add_child(new_hit) 
	var calculated_stats = character_stats.calculate_stats()
	var calc_damage: int = (base_damage + 
	(damage_scaling["STR"] * calculated_stats["STR"]) + 
	(damage_scaling["DEX"] * calculated_stats["DEX"]) + 
	(damage_scaling["INT"] * calculated_stats["INT"]) +
	(damage_scaling["WIS"] * calculated_stats["WIS"]) +
	(damage_scaling["CON"] * calculated_stats["CON"]))
	var calc_knockback: int = knockback
	
	new_hit.set_weapon_data(calc_damage, calc_knockback, target_layer)
	new_hit.global_position = GameDirector.level_gridmap.grid_to_globalpos(GameDirector.level_gridmap.globalpos_to_grid(global_position + direction * 4))
	new_hit.look_at(new_hit.global_position + direction, Vector3.UP)

func set_target_layer() -> void:
	match character_stats.character_tag:
		character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player
