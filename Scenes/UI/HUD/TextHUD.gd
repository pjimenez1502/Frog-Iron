extends Control
class_name TextHUD

@onready var player_data: RichTextLabel = %PlayerData
@onready var player_hp: RichTextLabel = %PlayerHP
@onready var player_stamina: RichTextLabel = %PlayerStamina
@onready var player_sanity: RichTextLabel = %PlayerIntegrity

func _ready() -> void:
	SignalBus.UpdatePlayerData.connect(update_data)
	SignalBus.PlayerHPUpdate.connect(update_hp)
	SignalBus.PlayerStaminaUpdate.connect(update_stamina)
	SignalBus.PlayerSanityUpdate.connect(update_sanity)

func update_data(species_data: Dictionary, _playermodel: CharacterModel, player_name: String) -> void:
	player_data.text = "[color=%s]%s, %s" % [Global.hud_color.to_html(), player_name, species_data["name"]]

func update_hp(max_hp: int, current_hp: int) -> void:
	var text_bar: String = ""
	for i: int in max_hp:
		if current_hp > i: text_bar += "/"
		else: text_bar += "-"
	player_hp.text = "[color=%s]Health:		[[color='red']%s[/color]] %d/%d" % [Global.hud_color.to_html(), text_bar, current_hp, max_hp]

func update_stamina(max_stamina: int, current_stamina: int) -> void:
	var text_bar: String = ""
	for i: int in max_stamina:
		if current_stamina > i: text_bar += "/"
		else: text_bar += "-"
	player_stamina.text = "[color=%s]Stamina:	[[color='green']%s[/color]] %d/%d" % [Global.hud_color.to_html(), text_bar, current_stamina, max_stamina]

func update_sanity(max_sanity: int, current_sanity:int) -> void:
	var text_bar: String = ""
	for i: int in max_sanity:
		if current_sanity > i: text_bar += "/"
		else: text_bar += "-"
	player_sanity.text = "[color=%s]Integrity:	[[color='purple']%s[/color]] %d/%d" % [Global.hud_color.to_html(), text_bar, current_sanity, max_sanity]
