extends Node3D
class_name MeleeWeapon

var character: Character

@onready var hits: Node = $Hits
@export var attack_hit: PackedScene

var target_layer: Util.CollisionLayer
var weapon_data: WeaponResource

var knockback: int = 0

func setup(_weapon_data: WeaponResource, _character: Character) -> void:
	weapon_data = _weapon_data
	character = _character
	
	update_weapon_status()
	set_target_layer()

func attack(hit_position: Vector2i) -> void:
	var new_hit: MeleeWeaponHit = attack_hit.instantiate()
	hits.add_child(new_hit) 
	
	var calc_damage: int = weapon_data.calculate_damage(character.character_stats)
	var calc_hitchance: int = weapon_data.calculate_hitchance(character.character_stats)
	var calc_knockback: int = knockback
	
	new_hit.set_weapon_data(calc_damage, calc_hitchance, calc_knockback, target_layer)
	new_hit.global_position = GameDirector.level_map.grid_to_globalpos(hit_position)
	#new_hit.look_at(new_hit.global_position + direction, Vector3.UP)

func update_weapon_status() -> void:
	SignalBus.PlayerWeaponMeleeUpdate.emit({
		"name": weapon_data.name,
		})

func set_target_layer() -> void:
	match character.character_stats.character_tag:
		character.character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character.character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player
