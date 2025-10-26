extends Node3D
class_name Gun

@export var enabled: bool

@onready var sprite: AnimatedSprite3D = $Sprite
@onready var projectile_container: Node = $ProjectileContainer

@export var projectile_prefab: PackedScene
@export var aim_speed: float = 3

func _physics_process(delta: float) -> void:
	if !enabled:
		return
	
	var mouse_pos = Util.get_mouse_pos(self)
	rotate_weapon(mouse_pos, delta)
	check_trigger(delta)

func check_trigger(delta: float) -> void:
	if Input.is_action_pressed("FIRE"):
		fire()

func fire() -> void:
	#spawn_projectile(null)
	pass



var target_rotation : float
func rotate_weapon(target_pos: Vector3, delta:float) -> void:
	global_transform = global_transform.interpolate_with(global_transform.looking_at(target_pos), delta * aim_speed)

#func spawn_projectile(weapon_stats: WeaponStats, strength: float= 1) -> void:
	#var projectile_instance : projectile = projectile_prefab.instantiate()
	#projectile_container.add_child(projectile_instance)
	##projectile_instance.weapon_stats.inherit_data(weapon_stats)
	#projectile_instance.global_position = global_position 
	#projectile_instance.global_transform.basis = global_transform.basis
	#projectile_instance.speed = projectile_instance.speed * strength
