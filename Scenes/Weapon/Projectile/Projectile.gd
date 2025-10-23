extends Node3D
class_name projectile

@export var speed: float = 10
@onready var hit_area: WeaponHit = $HitArea
@onready var weapon_stats: WeaponStats = %WeaponStats

var knockback : int
var damage : int

func _ready() -> void:
	hit_area.HIT.connect(hit)

func _physics_process(delta: float) -> void:
	global_position += -get_global_transform().basis.z * speed * delta

func hit(body: Node3D) -> void:
	print(body)
	queue_free()
