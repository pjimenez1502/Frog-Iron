extends CharacterBody3D
class_name enemy_eye


@onready var orbit_timer: Timer = %"Orbit Timer"
@onready var pupil_timer: Timer = %"Pupil Timer"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var eyelids: AnimatedSprite3D = $Sprite/Eyelids
@onready var pupil: AnimatedSprite3D = $Sprite/Pupil

@onready var attack_container: Node = $attack_container

@export var fixed : bool
@export var target : Node3D
var target_offset : Vector3
var hover_offset : Vector3

@export_group("Attack")
@export var eye_attack: PackedScene
@export var attack_count : int = 3
@export var attack_delay : int = 1
@export var area_offset_mult: float = 6
@export var area_scale: float = 1.6

func _ready() -> void:
	start_orbiting()

func _physics_process(delta: float) -> void:
	move(delta)
	pupil_look()
	check_distance()
	#print("curr_speed: ",curr_speed)

func shoot() -> void:
	var attack_points = []
	for i in attack_count:
		## get random point close to player
		var area_offset : Vector3 = Vector3(randf_range(-1,1), 0.05, randf_range(-2,-1)) * area_offset_mult
		var attack_position = target.global_position + area_offset
		
		#for j in i-1:
			#if attack_points[j].distance_to(attack_position) < 4:
			
		var projectile_instance : area_attack = eye_attack.instantiate()
		attack_container.add_child(projectile_instance)
		projectile_instance.global_position = attack_position
		projectile_instance.scale = Vector3.ONE * area_scale
		await get_tree().create_timer(0.6).timeout
		continue

## Movement
func start_orbiting() -> void:
	target_offset = find_point_around_target()
	orbit_timer.start(orbit_time + randf()*3)
	
func _on_orbit_timer_timeout() -> void:
	print("orbit")
	if randi_range(0,1) == 1:
		animation_player.play("Shoot")
		return
	
	target_offset = find_point_around_target()
	blink()

func move(delta) -> void:
	if fixed:
		return
	global_position = lerp(global_position, target.global_position + target_offset + hover_offset, delta * 0.6)
	#var direction = global_position.direction_to(target.global_position + target_offset)
	#print("dir: ",direction)
	#velocity = direction * curr_speed
	#move_and_slide()

## Eyelids
func check_distance() -> void:
	var distance = global_position.distance_to(target.global_position)
	eye_closed(distance < 5)

var is_eye_open
func eye_closed(value : bool) -> void:
	if value and is_eye_open:
		is_eye_open = false
		eyelids.play("Close")
		
	if !value and !is_eye_open:
		is_eye_open = true
		eyelids.play("Open")

func open() -> void:
	eyelids.play("Open_full")
func blink() -> void:
	eyelids.play("Blink")
func idle() -> void:
	animation_player.play("Idle")

## PUPIL
var pupil_offset : Vector3
func pupil_look() -> void:
	pupil.position = global_position.direction_to(target.global_position) * 0.3 + pupil_offset
	pupil.position.y = -pupil.position.z
	pupil.position.z = 0

func flicker_look() -> void: ## Flicker eye position by small ammounts to simulate fast eye movements
	pupil_timer.start(randf_range(0.1, 1))
	pupil_offset = Vector3(randf_range(-1,1),0,randf_range(-1,1)) * 0.05
	pass
	
## Float idly, swapping position around the player every x seconds. never let the player get too close.
## While idle, eye shines a bit dimmer.
## Gets ready to attack, eye shines brighter, eye gets a bit closer, indicating player to shoot. After a delay, shoot.
## invert colors when shooting?
## Sometimes, when idle, look straight center, as if looking at the camera.

##Util
@export_group("Orbit Settings")
@export var orbit_distance: float
@export var orbit_time: float
func find_point_around_target() -> Vector3:
	var offset_2d = (Vector2.RIGHT.rotated(randf_range(0, PI) + PI) * orbit_distance)
	return Vector3(offset_2d.x, 0, offset_2d.y)



func _on_hover_offset_timer_timeout() -> void:
	hover_offset = Vector3(randf_range(-1,1), 0 ,randf_range(-1,1)) * 4


func _on_projectile_detection_body_entered(body: Node3D) -> void:
	if body is projectile:
		#eyelids.speed_scale = 2
		eyelids.play("Blink")
		await get_tree().create_timer(1).timeout
		#eyelids.speed_scale = 1
