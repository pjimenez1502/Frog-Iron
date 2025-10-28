extends Node3D
class_name PlayerRangedWeapon

@export var enabled: bool
@export var weapon: RangedWeapon

func _physics_process(delta: float) -> void:
	if !enabled:
		weapon.visible = false
		return
	
	if Input.is_action_pressed("FIRE"):
		weapon.pressed(delta)
	if Input.is_action_just_released("FIRE"):
		weapon.released()
	
	var mouse_pos = Util.get_mouse_pos(self)
	weapon.rotate_weapon(mouse_pos, delta)
