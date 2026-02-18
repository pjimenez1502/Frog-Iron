extends Node
class_name CharacterProfile

@export var _name: String
enum ALIGNMENTS { Sil, Rock, Hybrid}
@export var alignment: ALIGNMENTS

func get_data() -> Dictionary:
	return { "name": _name, "alignment": alignment}
