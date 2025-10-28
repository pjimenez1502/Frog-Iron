extends Area3D
class_name MeleeWeaponHit

@export var temporal: bool
@export var duration: float = 0.2

var damage: int
var knockback: int

func _ready() -> void:
	body_entered.connect(_on_body_hit)

	var tween: Tween = get_tree().create_tween()
	await tween.tween_property($Sprite3D, "modulate:a", 0, duration).finished
	queue_free()

func _on_body_hit(body: Node3D) -> void:
	if body is not Character:
		return
	body.damage(damage)
	
	var direction: Vector3 = ((body.global_position - global_position) * Vector3(1,0,1)).normalized()
	body.knockback(direction, knockback)

func set_weapon_data(_damage: int, _knockback: int, target_layer: Util.CollisionLayer) -> void:
	damage = _damage
	knockback = _knockback
	set_collision_mask(target_layer)
