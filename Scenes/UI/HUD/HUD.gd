extends Control
class_name HUD

@onready var hp_bar: TextureProgressBar = %HP_Bar
@onready var hp_label: Label = %HP_Label
@onready var xp_bar: TextureProgressBar = %XP_Bar

func _ready() -> void:
	print("HUD READY")
	SignalBus.UpdatePlayerHP.connect(update_hp)

func update_hp(max_hp: int, current_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
	hp_label.text = "%d/%d" % [current_hp, max_hp]
