extends Character
class_name Enemy

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var attack: Node3D = %Attack
@onready var loot: Loot = %Loot
var close_target: Node3D
var far_target: Node3D
var target: Node3D

func _ready() -> void:
	super._ready()

func death() -> void:
	character_dead()
	attack_enabled(false)
	loot.drop_loot()
	# drop loot

func move() -> void:
	var direction: Vector3 = to_local(nav_agent.get_next_path_position()).normalized()
	if direction:
		velocity.x = direction.x * character_stats.speed
		velocity.z = direction.z * character_stats.speed
	else:
		velocity.x = move_toward(velocity.x, 0, character_stats.speed)
		velocity.z = move_toward(velocity.z, 0, character_stats.speed)
	
	super.move()



func make_nav_path() -> void:
	target = find_target()
	#print(target)
	if !target:
		nav_agent.target_position = global_position
		return
	nav_agent.target_position = target.global_position

func find_target() -> Node3D:
	if far_target && check_lineofsight():
		return far_target
	if close_target:
		return close_target
	return null

@onready var los_raycast: RayCast3D = %LOS_Raycast
func check_lineofsight() -> bool:
	los_raycast.global_position = global_position
	los_raycast.target_position = to_local(far_target.global_position) 
	if los_raycast.is_colliding():
		return false
	return true

func _on_timer_timeout() -> void:
	make_nav_path()




func _on_close_detection_body_entered(body: Node3D) -> void:
	close_target = body
func _on_close_detection_body_exited(body: Node3D) -> void:
	if close_target == body:
		close_target = null

func _on_far_detection_body_entered(body: Node3D) -> void:
	far_target = body
func _on_far_detection_body_exited(body: Node3D) -> void:
	if far_target == body:
		far_target = null

func attack_enabled(value: bool) -> void:
	attack.process_mode = Node.PROCESS_MODE_INHERIT if value else Node.PROCESS_MODE_DISABLED
