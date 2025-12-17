extends Character
class_name Enemy

@onready var loot: Loot = %Loot
@onready var enemy_input: EnemyInput = $GridMovement/EnemyInput

@export var spawn_cost: int = 1

func _ready() -> void:
	super._ready()
	GameDirector.enemy_list.append(self)
	
	character_grid_movement.CharacterActed.connect(update_is_visible)

func death() -> void:
	print("death")
	character_dead()
	loot.drop_loot()
	SignalBus.EnemyTurn.disconnect(enemy_input.play_turn)

func setup(enemy_data: EnemyResource) -> void:
	character_stats.set_stats(enemy_data.base_stats)

func character_dead() -> void:
	GameDirector.enemy_list.erase(self)
	super.character_dead()

func update_is_visible() -> void:
	visible = GameDirector.is_tile_visible(Util.vec3i_to_vec2i(character_grid_movement.grid_position))
