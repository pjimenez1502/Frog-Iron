extends Node3D
class_name MapTile

var current_visiblity: LevelMap.VISIBILITY

@export var blocks_vision: bool
@export var meshes: Array[MeshInstance3D]

var visible_material: Material = preload("uid://dxw8753d2eof4")
var seen_material: Material = preload("uid://cvh2d6w7tu0xm")

func _ready() -> void:
	update_visibility(LevelMap.VISIBILITY.UNSEEN)

func update_visibility(visibility: LevelMap.VISIBILITY) -> void:
	current_visiblity = visibility
	match visibility:
		LevelMap.VISIBILITY.UNSEEN:
			for mesh_instance: MeshInstance3D in meshes:
				visible = false
		LevelMap.VISIBILITY.SEEN:
			for mesh_instance: MeshInstance3D in meshes:
				visible = true
				mesh_instance.set_surface_override_material(0, seen_material)
		LevelMap.VISIBILITY.VISIBLE:
			for mesh_instance: MeshInstance3D in meshes:
				visible = true
				mesh_instance.set_surface_override_material(0, visible_material)

func out_of_vision() -> void:
	if current_visiblity == LevelMap.VISIBILITY.VISIBLE:
		update_visibility(LevelMap.VISIBILITY.SEEN)
