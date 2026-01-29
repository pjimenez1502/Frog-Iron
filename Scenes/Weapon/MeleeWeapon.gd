extends Weapon
class_name MeleeWeapon

@onready var hits: Node = $Hits
@export var attack_hit: PackedScene
var knockback: int = 0

func attack(target: Vector2i) -> void:
	var new_hit: MeleeWeaponHit = attack_hit.instantiate()
	hits.add_child(new_hit) 
	
	var calc_damage: int = weapon_data.calculate_damage(character.character_stats)
	var calc_hitchance: int = weapon_data.calculate_hitchance(character.character_stats)
	var calc_knockback: int = knockback
	
	new_hit.set_weapon_data(calc_damage, calc_hitchance, calc_knockback, target_layer)
	new_hit.global_position = Util.grid_to_globalpos(target)
	#new_hit.look_at(new_hit.global_position + direction, Vector3.UP)



func get_status_data() -> Dictionary:
	var data: Dictionary = {
		"type": "MELEE",
		"name": weapon_data.name,
	}
	return data
