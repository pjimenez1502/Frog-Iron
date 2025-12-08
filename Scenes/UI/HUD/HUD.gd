extends Control
class_name HUD

@onready var hp_bar: TextureProgressBar = %HP_Bar
@onready var hp_label: Label = %HP_Label
@onready var sanity_bar: TextureProgressBar = %SANITY_Bar
@onready var sanity_label: Label = $MarginContainer/VBoxContainer/SANITY_Bar/SANITY_Label
@onready var xp_bar: TextureProgressBar = %XP_Bar

func _ready() -> void:
	print("HUD READY")
	SignalBus.PlayerHPUpdate.connect(update_hp)
	SignalBus.PlayerSanityUpdate.connect(update_sanity)
	SignalBus.PlayerXPUpdate.connect(update_xp)

func update_hp(max_hp: int, current_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
	hp_label.text = "%d/%d" % [current_hp, max_hp]

func update_sanity(max_sanity: int, current_sanity:int) -> void:
	sanity_bar.max_value = max_sanity
	sanity_bar.value = current_sanity
	sanity_label.text = "%d/%d" % [current_sanity, max_sanity]

func update_xp(xp: int, max_xp:int) -> void:
	xp_bar.max_value = max_xp
	xp_bar.value = xp
