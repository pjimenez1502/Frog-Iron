extends Node3D
class_name Flail

@onready var _player: Player = $"../.."
@onready var path_3d: Path3D = $Path3D
@onready var morning_star: morningstar = %MorningStar

@export var enabled: bool
@export var base_damage: int = 1
@export var knockback : int = 100

func _ready() -> void:
	path_3d.curve.add_point(position)
	path_3d.curve.add_point(morning_star.position)
	
func _physics_process(delta: float) -> void:
	path_3d.curve.set_point_position(0, position)
	path_3d.curve.set_point_position(1, morning_star.position)
	
