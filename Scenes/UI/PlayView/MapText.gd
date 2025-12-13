extends RichTextLabel
class_name MapText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.MapUpdate.connect(update_map)

func update_map(map_text: String) -> void:
	text = map_text
