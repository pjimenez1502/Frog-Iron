extends Node3D
@onready var enemy: Enemy = $".."
@onready var attack_timer: Timer = $AttackTimer
@export var attack_cd: float
@export var close_weapon: Weapon

var attack_target: Character
var attack_available: bool = true

func _physics_process(delta: float) -> void:
	if attack_target:
		try_attack()

func try_attack() -> void:
	if !attack_available:
		return
	close_weapon.attack(dir_to_target())
	attack_available = false
	attack_timer.start()

func _on_close_detection_body_entered(body: Node3D) -> void:
	attack_target = body
func _on_close_detection_body_exited(body: Node3D) -> void:
	if attack_target == body:
		attack_target = null

func _on_attack_timer_timeout() -> void:
	attack_available = true

func dir_to_target() -> Vector3:
	return (attack_target.global_position - global_position).normalized()
