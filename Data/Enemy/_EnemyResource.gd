extends Resource
class_name EnemyResource

@export var name: String
enum ALIGNMENTS { SIL, ROCK, HUMAN }
@export var alignment: ALIGNMENTS
@export var description: String

@export var spawn_cost: int
@export var spawn_weight: int

@export var base_stats: Dictionary = {
	"STR": 6,
	"DEX": 6,
	"INT": 6,
	"WIS": 6,
	"CON": 6,
}

@export var scene: PackedScene
