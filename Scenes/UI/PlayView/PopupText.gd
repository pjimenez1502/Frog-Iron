extends Control
class_name PopupText

@onready var rich_text_label: RichTextLabel = %RichTextLabel

func _ready() -> void:
	SignalBus.ShowPopupText.connect(show_popup)
	InputBus.ui_INTERACT.connect(close_popup)
	close_popup()

func show_popup(text: String) -> void:
	rich_text_label.text = text
	visible = true

func close_popup() -> void:
	visible = false
