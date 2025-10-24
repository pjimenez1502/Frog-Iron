extends Node3D
class_name Weapon

@onready var hits: Node = $Hits
@export var attack_hit: PackedScene
@onready var weapon_stats: WeaponStats = %WeaponStats

func attack(direction:Vector3) -> void:
	var new_hit:  = attack_hit.instantiate()
	hits.add_child(new_hit)
	new_hit.set_weapon_data(weapon_stats)
	new_hit.global_position = global_position + direction
	new_hit.look_at(new_hit.global_position + direction, Vector3.UP)
