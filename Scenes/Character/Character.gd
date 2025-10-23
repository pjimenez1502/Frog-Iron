extends CharacterBody3D
class_name Character

@onready var animation_player: AnimationPlayer = $"Walk Animation Player"
@onready var sprite: AnimatedSprite3D = %Sprite

@onready var character_stats: CharacterStats = %CharacterStats

var dead: bool
var invert_look : bool

func _physics_process(delta: float) -> void:
	move()

func move() -> void:
	if dead:
		return
	move_and_slide()
	
	if velocity.length() < .1:
		animation_player.stop()
	else:
		animation_player.play("Walk")
	
	if invert_look:
		sprite.flip_h = !get_viewport().get_mouse_position().x < get_viewport().size.x / 2
	else:
		sprite.flip_h = get_viewport().get_mouse_position().x < get_viewport().size.x / 2

func character_dead() -> void:
	animation_player.stop()
	dead = true
	
	await get_tree().create_timer(1).timeout
	queue_free()
