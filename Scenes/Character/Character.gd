extends CharacterBody3D
class_name Character

@onready var walk_animation_player: AnimationPlayer = $"Walk AnimationPlayer"
@onready var sprite: AnimatedSprite3D = %Sprite

@onready var character_stats: CharacterStats = %CharacterStats

var invert_look : bool

func _physics_process(delta: float) -> void:
	move()

func move() -> void:
	move_and_slide()
	
	if velocity.length() == 0:
		walk_animation_player.stop()
	else:
		walk_animation_player.play("Walk")
	
	if invert_look:
		sprite.flip_h = !get_viewport().get_mouse_position().x < get_viewport().size.x / 2
	else:
		sprite.flip_h = get_viewport().get_mouse_position().x < get_viewport().size.x / 2
