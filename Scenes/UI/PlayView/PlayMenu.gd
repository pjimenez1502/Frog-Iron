extends Control
class_name PlayMenuView

@onready var character_menu: CharacterMenu = $"VBoxContainer/Menu Panel/MarginContainer/CharacterMenu"
@onready var inventory_menu: Control = $"VBoxContainer/Menu Panel/MarginContainer/InventoryMenu"

enum PlayMenu {CHARACTER, INVENTORY, SKILLS, PAUSE, NONE}
var current_menu: PlayMenu = PlayMenu.NONE

func _ready() -> void:
	close_menu()

func match_menu(menu: PlayMenu) -> void:
	if current_menu == menu:
		close_menu()
		return
	
	close_all_tabs()
	match menu:
		PlayMenu.CHARACTER:
			open_menu(menu)
			character_menu.visible = true
		PlayMenu.INVENTORY:
			open_menu(menu)
			inventory_menu.visible = true
		PlayMenu.SKILLS:
			open_menu(menu)
		PlayMenu.PAUSE:
			open_menu(menu)

func open_menu(menu: PlayMenu) -> void:
	visible = true
	current_menu = menu

func close_all_tabs() -> void:
	character_menu.visible = false
	inventory_menu.visible = false

func close_menu() -> void:
	visible = false
	current_menu = PlayMenu.NONE

func _tab_changed(tab: int) -> void:
	match_menu(tab)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MENU_PAUSE"):
		match_menu(PlayMenu.PAUSE)
	if event.is_action_pressed("MENU_CHARACTER"):
		match_menu(PlayMenu.CHARACTER)
