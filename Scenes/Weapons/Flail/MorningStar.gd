extends RigidBody3D
class_name morningstar

@onready var flail: flail = $".."
@onready var sprite: Sprite3D = $Sprite
@export var max_distance : float = 3

func _physics_process(delta: float) -> void:
	if !flail.enabled:
		return
	
	var distance = global_position.distance_to(flail.global_position)
	if distance > 1:
		apply_force(global_position.direction_to(flail.global_position) * 30 * distance)
		
	if Input.is_action_pressed("FIRE"):
		drag_ball(get_mouse_pos())
	
	var scale_increase = clamp(linear_velocity.length() / 16 - 0.5, 0, 1)
	#print(scale_increase)
	sprite.scale = Vector3.ONE * (1 + scale_increase)

func drag_ball(mouse_pos: Vector3):
	apply_force(global_position.direction_to(mouse_pos) * 40)
	







func get_mouse_pos():
	var camera = get_viewport().get_camera_3d()
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 1)
	var position3D = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
	if !position3D:
		return Vector3.ZERO
	return position3D
