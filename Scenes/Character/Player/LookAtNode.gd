extends Node3D


func _physics_process(delta: float) -> void:
	global_position = Util.get_mouse_pos(self)
