extends Node
class_name CharacterProfile

@export var _name: String
@export var alignment: EnemyResource.ALIGNMENTS

func set_data(character_data: Dictionary) -> void:
	_name = character_data["name"]
	alignment = character_data["alignment"]

func get_data() -> Dictionary:
	return { "name": _name, "alignment": alignment}
