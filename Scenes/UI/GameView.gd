extends Control
class_name GameView

const START_MENU = preload("uid://doa3ilpvhjo38")
const PLAY_VIEW = preload("uid://cj5nus31jyaxt")

func _ready() -> void:
	open_main_menu()
	SignalBus.LaunchDemoScene.connect(open_demo)

func set_view(scene: PackedScene) -> ViewScene:
	var view: ViewScene = scene.instantiate()
	add_child(view)
	return view

func open_main_menu() -> void:
	set_view(START_MENU)

func open_demo() -> void:
	var game_view = set_view(PLAY_VIEW)
	game_view.launch_demo_scene()
