extends Area3D
class_name WeaponHit

signal HIT

var damage: int
var knockback: int

func _ready() -> void:
	body_entered.connect(_on_body_hit)

func _on_body_hit(body: Character) -> void:
	HIT.emit(body)
	
	if body is not Character:
		return
	body.damage(damage)
	var direction: Vector3 = ((body.global_position - global_position) * Vector3(1,0,1)).normalized()
	body.knockback(direction, knockback)

func set_weapon_data(stats: WeaponStats) -> void:
	damage = stats.damage
	knockback = stats.knockback
	set_collision_mask(stats.target_layer)
