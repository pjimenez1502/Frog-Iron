extends Character
class_name Enemy

@onready var attack: Node3D = %Attack
@onready var loot: Loot = %Loot
@onready var enemy_input: EnemyInput = $GridMovement/EnemyInput

func _ready() -> void:
	GameDirector.enemy_list.append(self)
	
	super._ready()

func death() -> void:
	character_dead()
	attack_enabled(false)
	loot.drop_loot()


func attack_enabled(value: bool) -> void:
	attack.process_mode = Node.PROCESS_MODE_INHERIT if value else Node.PROCESS_MODE_DISABLED
