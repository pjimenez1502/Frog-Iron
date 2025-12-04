extends Sprite3D
class_name GameHealthBar

@onready var hp_bar: TextureProgressBar = %HP_Bar
@onready var hp_label: Label = %HP_Label
@onready var character_stats: CharacterStats = %CharacterStats

@export var hide_when_full: bool

func _ready() -> void:
	character_stats.HEALTH_UPDATE.connect(update_hp)

func update_hp(max_hp: int, current_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
	hp_label.text = "%d/%d" % [current_hp, max_hp]
	
	set_bar_visible(current_hp == max_hp)

func set_bar_visible(full_hp: bool) -> void:
	visible = !full_hp
	
	if !hide_when_full:
		visible = true
		return
