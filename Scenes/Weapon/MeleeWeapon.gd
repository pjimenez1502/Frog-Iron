extends Node3D
class_name MeleeWeapon

var character_stats: CharacterStats
var character_animation: CharacterAnimation

@onready var hits: Node = $Hits
@export var attack_hit: PackedScene

var target_layer: Util.CollisionLayer
var weapon_data: WeaponResource

var knockback: int = 0

func setup(_weapon_data: WeaponResource, _character_stats: CharacterStats, _character_animation: CharacterAnimation) -> void:
	weapon_data = _weapon_data
	character_stats = _character_stats
	character_animation = _character_animation
	set_target_layer()

func attack(hit_position: Vector3i) -> void:
	var new_hit: MeleeWeaponHit = attack_hit.instantiate()
	hits.add_child(new_hit) 
	
	var calc_damage: int = weapon_data.calculate_damage(character_stats)
	var calc_hitchance: int = weapon_data.calculate_hitchance(character_stats)
	var calc_knockback: int = knockback
	
	new_hit.set_weapon_data(calc_damage, calc_hitchance, calc_knockback, target_layer)
	new_hit.global_position = GameDirector.level_map.grid_to_globalpos(hit_position)
	#new_hit.look_at(new_hit.global_position + direction, Vector3.UP)


func set_target_layer() -> void:
	match character_stats.character_tag:
		character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player
