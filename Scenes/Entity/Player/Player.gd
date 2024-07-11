extends CharacterBody3D

const SPEED = 5.0

@onready var walk_animation_player: AnimationPlayer = $"Walk AnimationPlayer"
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

@export var hp : int = 3

var invert_look : bool

func _physics_process(delta: float) -> void:
	move()

func move() -> void:
	var input_dir := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	if velocity.length() == 0:
		walk_animation_player.stop()
	else:
		walk_animation_player.play("Walk")
	
	if invert_look:
		sprite.flip_h = !get_viewport().get_mouse_position().x < get_viewport().size.x / 2
	else:
		sprite.flip_h = get_viewport().get_mouse_position().x < get_viewport().size.x / 2

func damage() -> void:
	hp -= 1
	if hp <= 0:
		death()

func death() -> void:
	pass
