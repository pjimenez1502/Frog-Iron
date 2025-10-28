extends Node
class_name CharacterMenu

@onready var strength_value: RichTextLabel = %Strength_value
@onready var dexterity_value: RichTextLabel = %Dexterity_value
@onready var intelligence_value: RichTextLabel = %Intelligence_value
@onready var wisdom_value: RichTextLabel = %Wisdom_value
@onready var constitution_value: RichTextLabel = %Constitution_value

func _ready() -> void:
	SignalBus.StatsUpdate.connect(update_stats)

func update_stats(stats: Dictionary) -> void:
	strength_value.text = str(stats["STR"])
	dexterity_value.text = str(stats["DEX"])
	intelligence_value.text = str(stats["INT"])
	wisdom_value.text = str(stats["WIS"])
	constitution_value.text = str(stats["CON"])

func increase_stat(value: String) -> void:
	SignalBus.PlayerStatIncrease.emit(value, 1)
