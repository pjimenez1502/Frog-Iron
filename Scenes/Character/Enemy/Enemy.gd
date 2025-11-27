extends Character
class_name Enemy

@onready var loot: Loot = %Loot
@onready var enemy_input: EnemyInput = $GridMovement/EnemyInput

@export var spawn_cost: int = 1

func _ready() -> void:
	super._ready()
	GameDirector.enemy_list.append(self)

func death() -> void:
	print("death")
	character_dead()
	loot.drop_loot()
	SignalBus.EnemyTurn.disconnect(enemy_input.play_turn)
