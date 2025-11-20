extends Control
class_name GameView

const START_MENU = preload("uid://doa3ilpvhjo38")
const PLAY_VIEW = preload("uid://cj5nus31jyaxt")

func _ready() -> void:
	open_main_menu()
	SignalBus.LaunchDemoScene.connect(open_demo)
	SignalBus.LaunchDungeonScene.connect(open_dungeon)
	
	SignalBus.PauseGame.connect(pause_game)
	SignalBus.TimeScaleChange.connect(timescale_change)


## VIEWS
func set_view(scene: PackedScene) -> ViewScene:
	for child: Control in get_children():
		child.queue_free()
	var view: ViewScene = scene.instantiate()
	add_child(view)
	return view

func open_main_menu() -> void:
	set_view(START_MENU)

func open_demo() -> void:
	var game_view: PlayView = set_view(PLAY_VIEW)
	game_view.launch_demo_scene()

func open_dungeon() -> void:
	var game_view: PlayView = set_view(PLAY_VIEW)
	game_view.launch_dungeon_scene()


## TIME
var paused: bool
func pause_game(value: bool) -> void:
	paused = value
	print(value)
	Engine.time_scale = 0 if value else 1

func timescale_change(target: float, transition: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(Engine, "time_scale", target, transition).set_trans(Tween.TRANS_QUART)



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("_debug Reset"):
		open_demo()
