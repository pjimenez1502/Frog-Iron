extends CharacterBody3D
class_name Character

var animation_player: AnimationPlayer
var sprite: AnimatedSprite3D
var character_stats: CharacterStats

var velocity_mod: Vector3
var dead: bool
@export var turn_at_mouse : bool

var level: int = 1

func _ready() -> void:
	animation_player = $"Walk Animation Player"
	sprite = %Sprite
	character_stats = %CharacterStats
	
	character_stats.DEAD.connect(death)

func _physics_process(delta: float) -> void:
	gravity(delta)
	move(delta)

func move(_delta: float) -> void:
	if dead:
		return
	
	velocity += velocity_mod
	velocity_mod.x = move_toward(velocity_mod.x, 0, character_stats.speed)
	velocity_mod.z = move_toward(velocity_mod.z, 0, character_stats.speed)
	move_and_slide()
	
	if velocity.length() < .1:
		animation_player.stop()
	else:
		animation_player.play("Walk")
	
	sprite_look()

func sprite_look() -> void:
	if turn_at_mouse:
		sprite.flip_h = get_viewport().get_mouse_position().x < get_viewport().size.x / 2
	else:
		sprite.flip_h = velocity.x < 0

func gravity(delta: float) -> void:
	velocity.y = -300 * delta

func damage(_damage: int) -> void:
	character_stats.damage(_damage)

func death() -> void:
	character_dead()

func knockback(direction: Vector3, strength: float) -> void:
	velocity_mod += direction * strength * 10

func character_dead() -> void:
	animation_player.stop()
	dead = true
	
	await get_tree().create_timer(1).timeout
	queue_free()
