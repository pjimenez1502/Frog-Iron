extends PanelContainer
class_name ItemTooltip

var offset: Vector2 = Vector2(8,8)
enum TOOLTIP_ACTION { MOUSE_IN, MOUSE_OUT, R_CLICK }
enum TOOLTIP_TYPE { DESC, ACTION }
var current: TOOLTIP_TYPE

@onready var item_description: RichTextLabel = %ItemDescription
@onready var item_action_menu: ItemActionTooltip = %ItemActionMenu


func _ready() -> void:
	visible = false
	SignalBus.TooltipAction.connect(tooltip_handle)
	SignalBus.ShowTooltip.connect(show_tooltip)

func show_tooltip(content: Dictionary) -> void:
	if content.has("DESCRIPTION"):
		current = TOOLTIP_TYPE.DESC
		item_description.visible = true
		item_action_menu.visible = false
		item_description.text = content["DESCRIPTION"]
		return
	
	if content.has("ACTIONS"):
		current = TOOLTIP_TYPE.ACTION
		item_description.visible = false
		item_action_menu.visible = true
		item_action_menu.setup_actions(content["ACTIONS"], content["SLOT"])
		return





func tooltip_handle(action: TOOLTIP_ACTION) -> void:
	match action:
		TOOLTIP_ACTION.MOUSE_IN:
				toggle(true)
		TOOLTIP_ACTION.MOUSE_OUT:
			if current == TOOLTIP_TYPE.DESC: 
				toggle(false)
		TOOLTIP_ACTION.R_CLICK:
			toggle(true)

var opacity_tween: Tween = null
func toggle(value: bool) -> void:
	if !get_tree():
		return
	if opacity_tween:
		opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	if value:
		global_position = get_global_mouse_position() + offset + (Vector2(-248,0) if get_viewport_rect().size.x - get_global_mouse_position().x < 250 else Vector2(0,0))
		modulate.a = 0.0
		visible = true
		opacity_tween.tween_property(self, "modulate:a", 1.0, 0.1)
	else:
		await opacity_tween.tween_property(self, "modulate:a", 0.0, 0.1).finished
		visible = false

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.pressed:
		toggle(false)
