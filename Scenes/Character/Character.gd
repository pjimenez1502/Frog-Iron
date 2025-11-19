extends CharacterBody3D
class_name Character

var character_grid_movement: CharacterGridMovement
var character_stats: CharacterStats
var character_attack: CharacterAttack
var character_animation: CharacterAnimation

var velocity_mod: Vector3
var dead: bool
@export var turn_at_mouse : bool


var level: int = 1

func _ready() -> void:
	character_animation = %CharacterAnimation
	character_stats = %CharacterStats
	character_grid_movement = %GridMovement
	character_attack = %CharacterAttack
	
	character_grid_movement.setup(self)
	character_stats.DEAD.connect(death)

func _physics_process(delta: float) -> void:
	gravity(delta)
	

func gravity(delta: float) -> void:
	velocity.y = -300 * delta

func damage(_damage: int, _hitchance: int) -> void:
	character_stats.damage(_damage, _hitchance)

func death() -> void:
	character_dead()

func knockback(direction: Vector3, strength: float) -> void:
	velocity_mod += direction * strength * 20

func character_dead() -> void:
	await get_tree().create_timer(0.2).timeout
	queue_free()
