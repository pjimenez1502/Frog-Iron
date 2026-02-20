extends Character
class_name Enemy

@onready var enemy_inv: EnemyInventory = %Inventory
@onready var enemy_input: EnemyInput = $GridMovement/EnemyInput

@export var spawn_cost: int = 1

func _ready() -> void:
	super._ready()
	GameDirector.enemy_list.append(self)
	
	character_grid_movement.CharacterActed.connect(update_is_visible)

func death() -> void:
	print("death")
	%MouseHoverArea.on_death()
	character_dead()
	enemy_inv.drop_loot()
	if !SignalBus.EnemyTurn.is_connected(enemy_input.play_turn):
		return
	SignalBus.EnemyTurn.disconnect(enemy_input.play_turn)

func enemy_setup(enemy_data: EnemyResource) -> void:
	character_stats.set_stats(enemy_data.base_stats)
	character_profile.set_data({"name":enemy_data.name, "alignment": enemy_data.alignment})

func character_dead() -> void:
	GameDirector.enemy_list.erase(self)
	super.character_dead()

func update_is_visible() -> void:
	visible = GameDirector.is_tile_visible(character_grid_movement.grid_position)
