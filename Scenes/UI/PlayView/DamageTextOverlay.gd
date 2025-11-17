extends Control
class_name DamageTextOverlay

var text_size: int = 8
var offset: Vector3
var text_font: FontFile = preload("res://Assets/Font/m5x7.ttf")
enum TYPE { MESSAGE, DAMAGE, HEAL, POISON }
var text_colors : Dictionary = {
	"MESSAGE": Color(1.0, 1.0, 1.0, 1.0),
	"DAMAGE": Color(0.784, 0.0, 0.0, 1.0),
	"HEAL": Color(0.0, 0.784, 0.0, 1.0)
}

func _ready() -> void:
	SignalBus.DamageText.connect(display_text)

func display_text(value: String, parent: Node3D, type: TYPE = TYPE.MESSAGE) -> void:
	var popup_text : Label3D = Label3D.new()
	
	popup_text.text = str(value)
	popup_text.modulate = text_colors[TYPE.keys()[type]]
	
	popup_text.pixel_size = 0.005
	popup_text.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	popup_text.no_depth_test = true
	popup_text.fixed_size = true
	popup_text.font = text_font
	
	parent.add_child(popup_text)
	offset = (Vector3(randf_range(-0.5, 0.5), 2, randf_range(-0.5, 0.5)))
	popup_text.global_position = parent.global_position + offset
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup_text, "position:y", popup_text.position.y + 2, 0.25).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup_text, "position:y", popup_text.position.y, 0.5).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(popup_text, "scale", Vector3.ZERO, 0.25).set_ease(Tween.EASE_IN).set_delay(0.5)
	await tween.finished
	if popup_text:
		popup_text.queue_free()
