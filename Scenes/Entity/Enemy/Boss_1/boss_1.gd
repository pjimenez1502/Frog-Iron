extends Node3D

@export var _player : player
@export var distance : float = 20
@export var speed : float = 1

func _physics_process(delta: float) -> void:
	global_position.z = lerp(global_position.z, _player.global_position.z - distance, delta * speed)
