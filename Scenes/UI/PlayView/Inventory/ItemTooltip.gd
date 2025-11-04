extends PanelContainer
class_name ItemTooltip

var offset: Vector2 = Vector2(8,8)
@onready var content: RichTextLabel = %Content

func _ready() -> void:
	visible = false
	SignalBus.ShowTooltip.connect(show_tooltip)

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + offset + (Vector2(-248,0) if get_viewport_rect().size.x - get_global_mouse_position().x < 250 else Vector2(0,0))

func show_tooltip(value: bool, _content: String) -> void:
	toggle(value)
	content.text = _content

var opacity_tween: Tween = null
func toggle(value: bool) -> void:
	if !get_tree():
		return
	if opacity_tween:
		opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	if value:
		modulate.a = 0.0
		visible = true
		opacity_tween.tween_property(self, "modulate:a", 1.0, 0.1)
	else:
		await opacity_tween.tween_property(self, "modulate:a", 0.0, 0.1).finished
		visible = false
