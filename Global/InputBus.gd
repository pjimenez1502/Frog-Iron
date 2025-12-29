extends Node

var game_view: GameView

## MOVEMENT
signal input_MOVE
signal input_WAIT
signal input_MELEE
signal input_RANGED
signal input_INTERACT

signal action_ACCEPT
signal action_CANCEL

## CAMERA
signal camera_ZOOM
signal camera_ROTATE

## MENU
signal menu_CHARACTER
signal menu_INVENTORY
signal menu_SKILLS
signal menu_MAP
signal menu_PAUSE

## INVENTORY
signal inv_DROP

## UI
signal ui_INTERACT

func _physics_process(_delta: float) -> void:
	if game_view.current_view_focus == GameView.VIEW_FOCUS.GAME:
		if Input.is_action_pressed("move_UP"):
			input_MOVE.emit(0)
		if Input.is_action_pressed("move_DOWN"):
			input_MOVE.emit(2)
		if Input.is_action_pressed("move_LEFT"):
			input_MOVE.emit(1)
		if Input.is_action_pressed("move_RIGHT"):
			input_MOVE.emit(3)

func _input(event: InputEvent) -> void:
	## VIEW FOCUS LIMITED
	match game_view.current_view_focus:
		GameView.VIEW_FOCUS.GAME:
			if event.is_action_pressed("move_WAIT"):
				input_WAIT.emit()
			if event.is_action_pressed("move_INTERACT"):
				input_INTERACT.emit()
			if event.is_action_pressed("move_MELEE"):
				input_MELEE.emit()
			if event.is_action_pressed("move_RANGED"):
				input_RANGED.emit()
			
			if event.is_action_pressed("action_ACCEPT"):
				action_ACCEPT.emit()
			if event.is_action_pressed("action_CANCEL"):
				action_CANCEL.emit()
			
			if event.is_action_pressed("camera_ROTATE_LEFT"):
				camera_ROTATE.emit(1)
			if event.is_action_pressed("camera_ROTATE_RIGHT"):
				camera_ROTATE.emit(-1)
			if event.is_action_pressed("camera_ZOOM_IN"):
				camera_ZOOM.emit(1)
			if event.is_action_pressed("camera_ZOOM_OUT"):
				camera_ZOOM.emit(-1)
		
		GameView.VIEW_FOCUS.INVENTORY:
			if event.is_action_pressed("inv_DROP"):
				inv_DROP.emit()
	
	if game_view.current_view_focus != GameView.VIEW_FOCUS.MENU:
		if event.is_action_pressed("menu_CHARACTER"):
			menu_CHARACTER.emit()
		if event.is_action_pressed("menu_INVENTORY"):
			menu_INVENTORY.emit()
		if event.is_action_pressed("menu_SKILLS"):
			menu_SKILLS.emit()
		if event.is_action_pressed("menu_MAP"):
			menu_MAP.emit()
		if event.is_action_pressed("menu_PAUSE"):
			menu_PAUSE.emit()
		
		if event.is_action_pressed("UI_INTERACT"):
			ui_INTERACT.emit()
