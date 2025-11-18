extends Node3D
class_name Projectile

@export var base_speed: float = 20
@onready var hit_area: RangedWeaponHit = $HitArea

var damage : int
var knockback : int
var speed: float

func _ready() -> void:
	hit_area.HIT.connect(hit)

func _physics_process(delta: float) -> void:
	global_position += get_global_transform().basis.z * speed * delta

func setup_projectile(_damage: int, _knockback:int, target_layer: int) -> void:
	damage = _damage
	knockback = _knockback
	speed = base_speed
	hit_area.set_collision_mask(target_layer + Util.CollisionLayer.Terrain)

func hit(_body: Node3D) -> void:
	#print("Projectile %s hit %s" % [self, _body])
	queue_free()
