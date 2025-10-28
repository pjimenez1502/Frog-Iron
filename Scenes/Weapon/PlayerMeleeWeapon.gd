extends Node3D
class_name PlayerMeleeWeapon

@onready var attack_timer: Timer = %MeleeTimer

@export var enabled: bool
@export var swing_cd: float
@export var weapon: MeleeWeapon

var attack_available: bool = true

func _ready() -> void:
	attack_timer.wait_time = swing_cd

func _physics_process(_delta: float) -> void:
	if !enabled:
		weapon.visible = false
		return
	
	if Input.is_action_pressed("FIRE"):
		try_attack()

func try_attack() -> void:
	if !attack_available or !weapon:
		return
	weapon.attack(Util.get_mouse_direction(self))
	attack_available = false
	attack_timer.start()


func _on_attack_timer_timeout() -> void:
	attack_available = true
