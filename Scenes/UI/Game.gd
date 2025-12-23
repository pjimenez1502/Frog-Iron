extends Control
class_name GameView

const START_MENU = preload("uid://doa3ilpvhjo38")
const PLAY_VIEW = preload("uid://cj5nus31jyaxt")
const CREATION_VIEW = preload("uid://bq2ka0lnsoxmk")

enum VIEW_FOCUS { GAME, CHARACTER, INVENTORY, SKILLS, MAP, PAUSE, MENU }
var current_view_focus: VIEW_FOCUS

@onready var content: Control = $Content

func _ready() -> void:
	InputBus.game_view = self
	
	open_main_menu()
	SignalBus.LaunchDemoScene.connect(open_demo)
	SignalBus.LaunchDungeonScene.connect(open_dungeon)
	SignalBus.LaunchCharCreationScene.connect(open_character_creation)
	
	SignalBus.PauseGame.connect(pause_game)
	SignalBus.TimeScaleChange.connect(timescale_change)
	
	SignalBus.ViewFocusChange.connect(view_focus_update)
	view_focus_update(VIEW_FOCUS.MENU)


## VIEWS
func set_view(scene: PackedScene) -> ViewScene:
	for child: Control in content.get_children():
		child.queue_free()
	var view: ViewScene = scene.instantiate()
	content.add_child(view)
	return view

func open_main_menu() -> void:
	set_view(START_MENU)

func open_demo() -> void:
	var game_view: PlayView = set_view(PLAY_VIEW)
	game_view.launch_demo_scene()

func open_dungeon() -> void:
	var game_view: PlayView = set_view(PLAY_VIEW)
	game_view.launch_dungeon_scene(randi()) ## test seed

func open_character_creation() -> void:
	var creation_view: ViewScene = set_view(CREATION_VIEW)

## TIME
var paused: bool
func pause_game(value: bool) -> void:
	paused = value
	print(value)
	Engine.time_scale = 0 if value else 1

func timescale_change(target: float, transition: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(Engine, "time_scale", target, transition).set_trans(Tween.TRANS_QUART)



func view_focus_update(view_focus: VIEW_FOCUS) -> void:
	current_view_focus = view_focus
	print("CURRENT VIEW: %s" % VIEW_FOCUS.keys()[current_view_focus])
