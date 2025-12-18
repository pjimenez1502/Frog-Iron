extends Panel
class_name CharacterCreationMenu

@onready var species_title: RichTextLabel = %SpeciesTitle
@onready var species_desc: RichTextLabel = %SpeciesDesc
@onready var character_preview: Node3D = %CharacterPreview

var preview_model: Node3D

enum SPECIES { HUMAN, DRAKE, AVIAN, BOVINE }
var species_data: Dictionary = {
	SPECIES.HUMAN: { 
		"name": "Human",
		"description": "",
		"stats": {
			"STR": 2,
			"DEX": 2,
			"INT": 2,
			"WIS": 2,
			"CON": 2,
			},
		"scene": "res://Scenes/Character/Player/PlayerModels/Drake.tscn"
		},
	SPECIES.DRAKE: { 
		"name": "Drake",
		"description": "",
		"stats": {
			"STR": 2,
			"DEX": 2,
			"INT": 1,
			"WIS": 4,
			"CON": 2,
			},
		"scene": "res://Scenes/Character/Player/PlayerModels/Drake.tscn"
		},
	SPECIES.AVIAN: { 
		"name": "Avian",
		"description": "",
		"stats": {
			"STR": 0,
			"DEX": 4,
			"INT": 2,
			"WIS": 3,
			"CON": 1,
		},
		"scene": "res://Scenes/Character/Player/PlayerModels/Avian.tscn"
		},
	SPECIES.BOVINE: { 
		"name": "Bovine",
		"description": "",
		"stats": {
			"STR": 4,
			"DEX": 0,
			"INT": 0,
			"WIS": 2,
			"CON": 4,
		},
		"scene": "res://Scenes/Character/Player/PlayerModels/Bovine.tscn"
		},
}
var selected_species: SPECIES

func _ready() -> void:
	update_selected_species(selected_species)

func update_selected_species(species: SPECIES) -> void:
	selected_species = species
	species_title.text = species_data[species].name
	species_desc.text = species_description(species)
	update_preview()

func update_preview() -> void:
	if preview_model: 
		character_preview.remove_child(preview_model)
		preview_model.queue_free()
	
	preview_model = load(species_data[selected_species]["scene"]).instantiate()
	character_preview.add_child(preview_model)

func species_description(species: SPECIES) -> String:
	var desc: String = ""
	desc += species_data[species]["description"]
	desc += "\nStats:"
	for stat: String in species_data[species]["stats"]:
		desc += "\n -%s: +%d" % [stat, species_data[species]["stats"][stat]]
	return desc

func change_species_button(value: int) -> void:
	update_selected_species(wrap(selected_species + value, 0, SPECIES.size()))

func start() -> void:
	character_preview.remove_child(preview_model)
	SignalBus.SetStartPlayerData.emit.call_deferred(species_data[selected_species], preview_model, "PlayerName")
	SignalBus.LaunchDungeonScene.emit()
