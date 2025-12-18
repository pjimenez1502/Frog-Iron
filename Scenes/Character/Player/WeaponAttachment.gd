extends Node3D
class_name WeaponAttachment

@export var _position: Vector3
@export var _rotation: Vector3

func setup(bone_attachment: BoneAttachment3D) -> void:
	get_parent().remove_child.call_deferred(self)
	bone_attachment.add_child.call_deferred(self)
	position = _position
	rotation = _rotation
