extends ViewScene
class_name PlayView

@onready var sub_viewport: SubViewport = %SubViewport
@export var DEMO_DUNGEON: PackedScene
@export var GENERATED_DUNGEON: PackedScene

func _ready() -> void:
	SignalBus.PlayerDead.connect(on_player_death)

func set_scene(scene: PackedScene) -> Node3D:
	for child: Node3D in sub_viewport.get_children():
		child.queue_free()
		
	var instance: Node3D = scene.instantiate()
	sub_viewport.add_child(instance)
	return instance

func launch_demo_scene() -> void:
	set_scene(DEMO_DUNGEON)

func launch_dungeon_scene() -> void:
	var generated_dungeon: GeneratedDungeon = set_scene(GENERATED_DUNGEON)
	generated_dungeon.generate_dungeon(1)
	

func on_player_death() -> void:
	SignalBus.TimeScaleChange.emit(0.01, 0.5)
	SignalBus.ShowPopupText.emit("You are dead!")
