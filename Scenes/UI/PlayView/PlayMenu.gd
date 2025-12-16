extends Control
class_name PlayMenuView

@onready var menu_tabs: TabBar = %MenuTabs

@onready var menu_views : Array = [ %CharacterMenu, %InventoryMenu, %SkillsMenu, %MapMenu, %OptionsMenu ]

enum PlayMenu {CHARACTER, INVENTORY, SKILLS, MAP, PAUSE, NONE}
var current_menu: PlayMenu = PlayMenu.NONE

func _ready() -> void:
	setup_input()
	close_menu()

func match_menu(menu: PlayMenu) -> void:
	if current_menu == menu:
		close_menu()
		return
	
	close_all_tabs()
	open_menu(menu)
	menu_views[menu].visible = true

func open_menu(menu: PlayMenu) -> void:
	menu_tabs.current_tab = menu
	visible = true
	current_menu = menu

func close_all_tabs() -> void:
	for menu: Panel in menu_views:
		menu.visible = false

func close_menu() -> void:
	SignalBus.ViewFocusChange.emit(GameView.VIEW_FOCUS.GAME)
	visible = false
	current_menu = PlayMenu.NONE

func open_character() -> void:
	SignalBus.ViewFocusChange.emit(GameView.VIEW_FOCUS.CHARACTER)
	if current_menu == PlayMenu.NONE:
		match_menu(PlayMenu.CHARACTER)
	else:
		close_menu()

func open_inventory() -> void:
	SignalBus.ViewFocusChange.emit(GameView.VIEW_FOCUS.INVENTORY)
	if current_menu == PlayMenu.NONE:
		match_menu(PlayMenu.INVENTORY)
	else:
		close_menu()

func open_skills() -> void:
	SignalBus.ViewFocusChange.emit(GameView.VIEW_FOCUS.SKILLS)
	if current_menu == PlayMenu.NONE:
		match_menu(PlayMenu.SKILLS)
	else:
		close_menu()

func open_map() -> void:
	SignalBus.ViewFocusChange.emit(GameView.VIEW_FOCUS.MAP)
	if current_menu == PlayMenu.NONE:
		match_menu(PlayMenu.MAP)
	else:
		close_menu()

func open_pause() -> void:
	SignalBus.ViewFocusChange.emit(GameView.VIEW_FOCUS.PAUSE)
	if current_menu == PlayMenu.NONE:
		match_menu(PlayMenu.PAUSE)
	else:
		close_menu()

func _tab_changed(tab: int) -> void:
	match_menu(tab)



func setup_input() -> void:
	InputBus.menu_CHARACTER.connect(open_character)
	InputBus.menu_INVENTORY.connect(open_inventory)
	InputBus.menu_SKILLS.connect(open_skills)
	InputBus.menu_MAP.connect(open_map)
	InputBus.menu_PAUSE.connect(open_pause)
