class_name WeaponHit
extends Area3D

@onready var weapon_stats: WeaponStats = %WeaponStats

func _ready() -> void:
	body_entered.connect(_on_body_hit)

func _on_body_hit(character: Character) -> void:
	#print(character)
	character.character_stats.damage(weapon_stats.damage)
