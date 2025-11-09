extends Node3D
class_name CameraPivot

@onready var camera: Camera3D = %Camera

@export var far_position: Vector3 = Vector3(0, 7, 7)
@export var far_rotation: Vector3 = Vector3(-38, 0, 0)

@export var close_position: Vector3 = Vector3(0, 1.5, 3.8)
@export var close_rotation: Vector3 = Vector3(0, 0, 0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ZOOM_IN"):
		move_target(1, delta)
	if Input.is_action_just_pressed("ZOOM_OUT"):
		move_target(-1, delta)
	move_camera(delta)

@export var zoom_mult: int = 10
var zoom_value: float
var pos_target: Vector3
var rot_target: Vector3
@export var cam_speed: int = 10

func move_target(direction: int, delta: float) -> void:
	zoom_value = clampf(zoom_value + direction*delta * zoom_mult, 0, 1)
	pos_target = lerp(far_position, close_position, zoom_value)
	rot_target = lerp(far_rotation, close_rotation, zoom_value)

func move_camera(delta) -> void:
	camera.position = lerp(camera.position, pos_target, delta * cam_speed)
	camera.rotation.x = lerp_angle(camera.rotation.x, deg_to_rad(rot_target.x), delta * cam_speed)
