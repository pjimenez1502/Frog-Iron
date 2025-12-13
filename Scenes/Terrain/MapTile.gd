extends Node3D
class_name MapTile

var current_visiblity: LevelMap.VISIBILITY

@export var blocks_vision: bool
@export var meshes: Array[MeshInstance3D]

var visible_material: Material = preload("uid://dxw8753d2eof4")
var seen_material: Material = preload("uid://cvh2d6w7tu0xm")

const SEEN_COLOR: Color = Color(.5, .5, .5)
const VISIBLE_COLOR: Color = Color(1.0, 1.0, 1.0, 1.0)

func _ready() -> void:
	update_visibility(LevelMap.VISIBILITY.UNSEEN)

func update_visibility(visibility: LevelMap.VISIBILITY) -> void:
	current_visiblity = visibility
	match visibility:
		LevelMap.VISIBILITY.UNSEEN:
			for mesh_instance: MeshInstance3D in meshes:
				visible = false
				set_instance_tint(Color(), mesh_instance)
		LevelMap.VISIBILITY.SEEN:
			for mesh_instance: MeshInstance3D in meshes:
				visible = true
				smooth_tint(mesh_instance, SEEN_COLOR)
		LevelMap.VISIBILITY.VISIBLE:
			for mesh_instance: MeshInstance3D in meshes:
				visible = true
				smooth_tint(mesh_instance, VISIBLE_COLOR)

func smooth_tint(mesh_instance: MeshInstance3D, color: Color) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_method(set_instance_tint.bind(mesh_instance), mesh_instance.get_instance_shader_parameter("tint"), color, 0.5)

func set_instance_tint(color: Color, mesh_instance: MeshInstance3D) -> void:
	mesh_instance.set_instance_shader_parameter("tint", color)

func out_of_vision() -> void:
	if current_visiblity == LevelMap.VISIBILITY.VISIBLE:
		update_visibility(LevelMap.VISIBILITY.SEEN)
