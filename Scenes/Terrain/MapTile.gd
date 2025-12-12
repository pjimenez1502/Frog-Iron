extends Node3D
class_name MapTile

@onready var unseen: MeshInstance3D = %Unseen
@onready var seen: MeshInstance3D = %Seen

var current_visiblity: LevelMap.VISIBILITY

@export var blocks_vision: bool

func _ready() -> void:
	update_visibility(LevelMap.VISIBILITY.UNSEEN)

func update_visibility(visibility: LevelMap.VISIBILITY) -> void:
	current_visiblity = visibility
	match visibility:
		LevelMap.VISIBILITY.UNSEEN:
			unseen.visible = true
		LevelMap.VISIBILITY.SEEN:
			unseen.visible = false
			seen.visible = true
		LevelMap.VISIBILITY.VISIBLE:
			unseen.visible = false
			seen.visible = false

func out_of_vision() -> void:
	if current_visiblity == LevelMap.VISIBILITY.VISIBLE:
		update_visibility(LevelMap.VISIBILITY.SEEN)
