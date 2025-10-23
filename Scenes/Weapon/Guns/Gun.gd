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
	
	var mouse_pos = get_mouse_pos()
	rotate_weapon(mouse_pos, delta)

func check_trigger(delta: float) -> void:
	if Input.is_action_pressed("FIRE"):
		fire()

func fire() -> void:
	spawn_projectile(1)



var target_rotation : float
func rotate_weapon(target_pos: Vector3, delta:float) -> void:
	global_transform = global_transform.interpolate_with(global_transform.looking_at(target_pos, Vector3.UP), delta * aim_speed)

func spawn_projectile(strength: float) -> void:
	var projectile_instance : projectile = projectile_prefab.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.global_position = global_position 
	projectile_instance.global_transform.basis = global_transform.basis
	projectile_instance.speed = projectile_instance.speed * strength

func get_mouse_pos():
	var camera = get_viewport().get_camera_3d()
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 1)
	var position3D = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
	if !position3D:
		return Vector3.ZERO
	return position3D
