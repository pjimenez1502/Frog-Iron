extends Node3D
class_name Bow

@onready var sprite: AnimatedSprite3D = $Sprite
@onready var projectile_container: Node = $ProjectileContainer

@export var enabled: bool
@export var projectile_prefab: PackedScene

var draw_strength : float
var drawing : float

func _ready() -> void:
	sprite.play("drawn_0")

func _physics_process(delta: float) -> void:
	if !enabled:
		return
	var mouse_pos = get_mouse_pos()

	rotate_weapon(mouse_pos, delta)
	
	if Input.is_action_pressed("FIRE"):
		bow_draw(mouse_pos, delta)
	if Input.is_action_just_released("FIRE"):
		fire(mouse_pos)

var target_rotation : float
func rotate_weapon(target_pos: Vector3, delta:float) -> void:
	var parent_transform = get_parent_node_3d().global_transform
	var new_transform = parent_transform.looking_at(target_pos, Vector3.UP)
	get_parent_node_3d().global_transform = parent_transform.interpolate_with(new_transform, delta * 2)
	
	#if drawing:
		#target_rotation = (global_position - target_pos).angle()
	#else:
		#target_rotation = (target_pos - global_position).angle()
		#
	#sprite.rotation = lerp_angle(sprite.rotation, target_rotation, delta * 6)

func bow_draw(mouse_pos: Vector3, delta: float) -> void:
	drawing = true
	var distance = global_position.distance_squared_to(mouse_pos)
	var target_strength = clampf(distance / 8, 0, 1.1)
	
	draw_strength = snapped(lerp(draw_strength, target_strength, delta * 4), 0.01)
	var str_value = int(draw_strength*4)
	sprite.play(str("drawn_",str_value))

func fire(mouse_pos: Vector3) -> void:
	#print(draw_strength)
	if draw_strength < 0.25:
		draw_strength = 0
		return
		
	spawn_projectile(draw_strength)
	
	sprite.play("drawn_0")
	drawing = false
	draw_strength = 0

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
