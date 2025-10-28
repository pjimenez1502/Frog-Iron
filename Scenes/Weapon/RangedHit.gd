extends Area3D
class_name RangedWeaponHit

signal HIT
@onready var projectile: Projectile = $".."

func _ready() -> void:
	body_entered.connect(_on_body_hit)

func _on_body_hit(body: Node3D) -> void:
	HIT.emit(body)
	
	if body is not Character:
		return
	body.damage(projectile.damage)
	var direction: Vector3 = ((body.global_position - global_position) * Vector3(1,0,1)).normalized()
	body.knockback(direction, projectile.knockback)
