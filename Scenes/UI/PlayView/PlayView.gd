extends ViewScene
class_name PlayView

@onready var world_subviewport: SubViewport = %"World SubViewport"
@export var DEMO_DUNGEON: PackedScene
@export var GENERATED_DUNGEON: PackedScene

func _ready() -> void:
	SignalBus.PlayerDead.connect(on_player_death)
	SignalBus.ViewFocusChange.emit(GameView.VIEW_FOCUS.GAME)

func set_scene(scene: PackedScene) -> Node3D:
	for child: Node3D in world_subviewport.get_children():
		child.queue_free()
		
	var instance: Node3D = scene.instantiate()
	world_subviewport.add_child(instance)
	return instance

func launch_dungeon_scene(_seed: int = -1) -> void:
	var generated_dungeon: GeneratedDungeon = set_scene(GENERATED_DUNGEON)
	
	var RNG: RandomNumberGenerator = RandomNumberGenerator.new()
	if _seed != -1:
		RNG.seed = _seed
	var DUNGEON_SEED: int = RNG.randi()
	generated_dungeon.generate_dungeon(1, DUNGEON_SEED)


func launch_demo_scene() -> void:
	set_scene(DEMO_DUNGEON)


func on_player_death() -> void:
	SignalBus.TimeScaleChange.emit(0.01, 0.5)
	SignalBus.ShowPopupText.emit("You are dead!")
