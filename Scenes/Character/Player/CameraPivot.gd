extends Node3D
class_name CameraPivot

@onready var camera: Camera3D = %Camera

@export var far_position: Vector3 = Vector3(0, 12, 10)
@export var far_rotation: Vector3 = Vector3(-50, 0, 0)

var mid_position: Vector3 = Vector3(0, 7, 7)
var mid_rotation: Vector3 = Vector3(-38, 0, 0)

@export var close_position: Vector3 = Vector3(0, 1.5, 5)
@export var close_rotation: Vector3 = Vector3(0, 0, 0)

func _ready() -> void:
	GameDirector.current_camera = camera
	
	zoom_value = 0
	pos_target = far_position
	rot_target = far_rotation
	
	SignalBus.UpdateCameraRotation.connect(rotate_camera)
	setup_input()

func setup_input() -> void:
	InputBus.camera_ROTATE.connect(turn_camera)
	InputBus.camera_ZOOM.connect(move_target)

func _process(delta: float) -> void:
	move_camera(delta)

@export var zoom_mult: float = 0.05
var zoom_value: float
var pos_target: Vector3
var rot_target: Vector3
@export var cam_speed: int = 10

func move_target(direction: int) -> void:
	zoom_value = clampf(zoom_value + direction * zoom_mult, 0, 1)
	pos_target = lerp(far_position, close_position, zoom_value)
	rot_target = lerp(far_rotation, close_rotation, zoom_value)

func move_camera(delta: float) -> void:
	camera.position = lerp(camera.position, pos_target, delta * cam_speed)
	camera.rotation.x = lerp_angle(camera.rotation.x, deg_to_rad(rot_target.x), delta * cam_speed)

var rotate_free: bool = true
var rotation_time: float = 0.15
var current_camera_direction: int = 0

func turn_camera(direction: int) -> void:
	if !rotate_free:
		return
	rotate_free = false
	
	current_camera_direction = current_camera_direction + direction
	current_camera_direction = current_camera_direction % 4 if current_camera_direction >= 0 else current_camera_direction+4
	SignalBus.UpdateCameraRotation.emit(current_camera_direction)

func rotate_camera(direction: int) -> void:
	var rot_tween: Tween = get_tree().create_tween()
	rot_tween.tween_method(smooth_rotation.bind(direction * deg_to_rad(90)), 0.0, 1.0, rotation_time)
	await rot_tween.finished
	rotate_free = true

func smooth_rotation(weight: float, angle: float) -> void:
	rotation.y = lerp_angle(rotation.y, angle, weight)
