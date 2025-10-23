extends Node3D
class_name Weapon

@onready var hits: Node = $Hits
@export var attack_hit: PackedScene

func attack(direction:Vector3) -> void:
	var new_hit: WeaponHitTemp = attack_hit.instantiate()
	hits.add_child(new_hit)
	new_hit.global_position = global_position + direction
	new_hit.look_at(new_hit.global_position + direction, Vector3.UP)
