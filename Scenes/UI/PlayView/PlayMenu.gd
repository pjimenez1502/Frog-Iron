extends Control
class_name PlayMenuView

@onready var menu_tabs: TabBar = %MenuTabs

@onready var menu_views : Array = [ %CharacterMenu, %InventoryMenu, %SkillsMenu, %OptionsMenu ]

enum PlayMenu {CHARACTER, INVENTORY, SKILLS, PAUSE, NONE}
var current_menu: PlayMenu = PlayMenu.NONE

func _ready() -> void:
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
	visible = false
	current_menu = PlayMenu.NONE

func open_character() -> void:
	if current_menu == PlayMenu.NONE:
		match_menu(PlayMenu.CHARACTER)
	else:
		close_menu()

func open_inventory() -> void:
	if current_menu == PlayMenu.NONE:
		match_menu(PlayMenu.INVENTORY)
	else:
		close_menu()

func open_pause() -> void:
	if current_menu == PlayMenu.NONE:
		match_menu(PlayMenu.PAUSE)
	else:
		close_menu()

func _tab_changed(tab: int) -> void:
	match_menu(tab)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MENU_PAUSE"):
		open_pause()
	if event.is_action_pressed("MENU_CHARACTER"):
		open_character()
	if event.is_action_pressed("MENU_INVENTORY"):
		open_inventory()
