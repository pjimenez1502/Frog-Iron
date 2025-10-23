extends Area3D
class_name WeaponHit

@export var weapon_stats: WeaponStats

signal HIT

func _ready() -> void:
	body_entered.connect(_on_body_hit)

func _on_body_hit(body: Node3D) -> void:
	HIT.emit(body)
	
	if body is not Character:
		return
	body.character_stats.damage(weapon_stats.damage)
	var direction: Vector3 = ((body.global_position - global_position) * Vector3(1,0,1)).normalized()
	body.knockback(direction, weapon_stats.knockback)
	
