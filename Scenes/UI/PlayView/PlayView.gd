extends ViewScene
class_name PlayView

@onready var sub_viewport: SubViewport = %SubViewport
@export var DEMO_DUNGEON: PackedScene

func set_scene(scene: PackedScene) -> void:
	for child: Node3D in sub_viewport.get_children():
		child.queue_free()
	sub_viewport.add_child(scene.instantiate())

func launch_demo_scene() -> void:
	set_scene(DEMO_DUNGEON)
