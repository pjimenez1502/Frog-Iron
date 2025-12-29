extends Control
class_name Cursor

@onready var default: TextureRect = $DEFAULT
@onready var melee: TextureRect = $MELEE
@onready var ranged: TextureRect = $RANGED
@onready var interact: TextureRect = $INTERACT

enum CURSOR { DEFAULT, MELEE, RANGED, INTERACT }

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SignalBus.CursorUpdate.connect(set_cursor)
	set_cursor(CURSOR.DEFAULT)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func set_cursor(cursor: CURSOR) -> void:
	match cursor:
		CURSOR.DEFAULT:
			default.visible = true
			melee.visible = false
			ranged.visible = false
			interact.visible = false
		CURSOR.MELEE:
			default.visible = false
			melee.visible = true
			ranged.visible = false
			interact.visible = false
		CURSOR.RANGED:
			default.visible = false
			melee.visible = false
			ranged.visible = true
			interact.visible = false
		CURSOR.INTERACT:
			default.visible = false
			melee.visible = false
			ranged.visible = false
			interact.visible = true
	
