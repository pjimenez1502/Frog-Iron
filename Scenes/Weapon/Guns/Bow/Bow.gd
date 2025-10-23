extends Gun
class_name Bow

@export var draw_speed: float = 3
var draw_strength : float

#var drawing : float

func _ready() -> void:
	sprite.play("drawn_0")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	check_trigger(delta)

func check_trigger(delta: float) -> void:
	if Input.is_action_pressed("FIRE"):
		bow_draw(delta)
	if Input.is_action_just_released("FIRE"):
		fire()

func bow_draw(delta: float) -> void:
	draw_strength = snapped(lerp(draw_strength, 1.0, delta * draw_speed), 0.01)
	var str_value = int(draw_strength*4)
	sprite.play(str("drawn_",str_value))

func fire() -> void:
	if draw_strength < 0.25:
		draw_strength = 0
		return
	spawn_projectile(draw_strength)
	
	sprite.play("drawn_0")
	#drawing = false
	draw_strength = 0
