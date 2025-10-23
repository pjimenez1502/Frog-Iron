extends Node
class_name WeaponStats

@export var base_damage: int
var damage: float
@export var knockback: float

func _ready() -> void:
	damage = base_damage

func inherit_data(stats: WeaponStats) -> void:
	damage = stats.damage
	knockback = stats.knockback
