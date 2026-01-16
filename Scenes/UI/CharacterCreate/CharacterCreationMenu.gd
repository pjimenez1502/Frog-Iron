extends Panel
class_name CharacterCreationMenu

@onready var species_title: RichTextLabel = %SpeciesTitle
@onready var species_desc: RichTextLabel = %SpeciesDesc
@onready var character_preview: Node3D = %CharacterPreview
@onready var name_edit: LineEdit = %NameEdit

var preview_model: CharacterModel

enum SPECIES { HUMAN, DRAKE, AVIAN, BOVINE }
var AVAILABLE_SPECIES: Array[SPECIES] = [ SPECIES.DRAKE ]
var selected_species: int

var species_data: Dictionary = {
	SPECIES.HUMAN: { 
		"name": "Human",
		"description": "",
		"stats": {
			"STR": 4,
			"DEX": 4,
			"INT": 4,
			"WIS": 4,
			"CON": 4,
			},
		"scene": "res://Scenes/Character/Player/PlayerModels/Drake.tscn"
		},
	SPECIES.DRAKE: { 
		"name": "Drake",
		"description": "",
		"stats": {
			"STR": 4,
			"DEX": 4,
			"INT": 3,
			"WIS": 6,
			"CON": 4,
			},
		"scene": "res://Scenes/Character/Player/PlayerModels/Drake.tscn"
		},
	SPECIES.AVIAN: { 
		"name": "Avian",
		"description": "",
		"stats": {
			"STR": 2,
			"DEX": 8,
			"INT": 4,
			"WIS": 6,
			"CON": 2,
		},
		"scene": "res://Scenes/Character/Player/PlayerModels/Avian.tscn"
		},
	SPECIES.BOVINE: { 
		"name": "Bovine",
		"description": "",
		"stats": {
			"STR": 6,
			"DEX": 2,
			"INT": 2,
			"WIS": 4,
			"CON": 6,
		},
		"scene": "res://Scenes/Character/Player/PlayerModels/Bovine.tscn"
		},
}


func _ready() -> void:
	update_selected_species(0)

func update_selected_species(index: int) -> void:
	selected_species = AVAILABLE_SPECIES[index]
	species_title.text = species_data[AVAILABLE_SPECIES[index]].name
	species_desc.text = species_description(AVAILABLE_SPECIES[index])
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

var index: int
func change_species_button(value: int) -> void:
	index = wrap(index + value, 0, AVAILABLE_SPECIES.size())
	update_selected_species(index)

func start() -> void:
	character_preview.remove_child(preview_model)
	SignalBus.UpdatePlayerData.emit.call_deferred(species_data[selected_species], preview_model, name_edit.text)
	SignalBus.LaunchDungeonScene.emit()
