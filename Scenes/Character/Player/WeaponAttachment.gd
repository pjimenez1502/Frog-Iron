extends Node3D
class_name WeaponAttachment

@export var hand: BoneAttachment3D
@export var _position: Vector3
@export var _rotation: Vector3

func _ready() -> void:
	get_parent().remove_child.call_deferred(self)
	hand.add_child.call_deferred(self)
	position = _position
	rotation = _rotation
