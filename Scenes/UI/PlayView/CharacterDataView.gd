extends Node
class_name CharacterMenu

@onready var strength_button: TextureButton = %Strength_button
@onready var dexterity_button: TextureButton = %Dexterity_button
@onready var intelligence_button: TextureButton = %Intelligence_button
@onready var wisdom_button: TextureButton = %Wisdom_button
@onready var constitution_button: TextureButton = %Constitution_button


@onready var strength_value: RichTextLabel = %Strength_value
@onready var dexterity_value: RichTextLabel = %Dexterity_value
@onready var intelligence_value: RichTextLabel = %Intelligence_value
@onready var wisdom_value: RichTextLabel = %Wisdom_value
@onready var constitution_value: RichTextLabel = %Constitution_value

@onready var available_increase: RichTextLabel = %AvailableIncrease

func _ready() -> void:
	SignalBus.StatsUpdate.connect(update_stats)
	SignalBus.AvailableStatUP.connect(update_availableUP)

func update_stats(stats: Dictionary) -> void:
	strength_value.text = str(stats["STR"])
	dexterity_value.text = str(stats["DEX"])
	intelligence_value.text = str(stats["INT"])
	wisdom_value.text = str(stats["WIS"])
	constitution_value.text = str(stats["CON"])

func update_availableUP(value: int) -> void:
	available_increase.text = "Available: (%d)" % value
	set_statup_buttons_active(value > 0)

func set_statup_buttons_active(value: bool) -> void:
	strength_button.disabled = !value
	dexterity_button.disabled = !value
	intelligence_button.disabled = !value
	wisdom_button.disabled = !value
	constitution_button.disabled = !value

func increase_stat(value: String) -> void:
	SignalBus.PlayerStatIncrease.emit(value, 1)
