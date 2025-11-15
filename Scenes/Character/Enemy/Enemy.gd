extends Character
class_name Enemy

@onready var loot: Loot = %Loot
@onready var enemy_input: EnemyInput = $GridMovement/EnemyInput

func _ready() -> void:
	super._ready()
	GameDirector.enemy_list.append(self)

func death() -> void:
	character_dead()
	loot.drop_loot()
