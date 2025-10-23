extends Area3D
class_name WeaponHit

@export var weapon_stats: WeaponStats

func _ready() -> void:
	body_entered.connect(_on_body_hit)

func _on_body_hit(character: Character) -> void:
	character.character_stats.damage(weapon_stats.damage)
