extends ViewScene
class_name PlayView

@onready var sub_viewport: SubViewport = %SubViewport
@export var DEMO_DUNGEON: PackedScene

func _ready() -> void:
	SignalBus.PlayerDead.connect(on_player_death)

func set_scene(scene: PackedScene) -> void:
	for child: Node3D in sub_viewport.get_children():
		child.queue_free()
	sub_viewport.add_child(scene.instantiate())

func launch_demo_scene() -> void:
	set_scene(DEMO_DUNGEON)

func on_player_death() -> void:
	SignalBus.TimeScaleChange.emit(0.01, 0.5)
	SignalBus.ShowPopupText.emit("You are dead!")
