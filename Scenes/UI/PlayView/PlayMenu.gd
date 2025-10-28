extends Control
class_name PlayMenuView

@onready var character_menu: CharacterMenu = $"VBoxContainer/Menu Panel/MarginContainer/CharacterMenu"

enum PlayMenu {NONE, PAUSE, CHARACTER, SKILLS}
var current_menu: PlayMenu

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

func open_menu(menu: PlayMenu) -> void:
	visible = true
	current_menu = menu

func close_all_tabs() -> void:
	character_menu.visible = true

func close_menu() -> void:
	visible = false
	current_menu = PlayMenu.NONE

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MENU_PAUSE"):
		match_menu(PlayMenu.PAUSE)
	if event.is_action_pressed("MENU_CHARACTER"):
		match_menu(PlayMenu.CHARACTER)
