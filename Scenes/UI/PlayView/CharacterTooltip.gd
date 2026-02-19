extends PanelContainer
class_name CharacterTooltip

@onready var character_data: RichTextLabel = %CharacterData
var offset: Vector2 = Vector2(16,-16)
var current: Node3D

func _ready() -> void:
	visible = false
	SignalBus.CharacterTooltipShow.connect(show_tooltip)

func show_tooltip(value: bool, origin: Node3D, data: Dictionary = {}) -> void:
	if !value and origin == current:
		visible = false
		return
	
	visible = true
	current = origin
	position = Util.unproject_position(origin) + offset
	character_data.text = data["name"]
