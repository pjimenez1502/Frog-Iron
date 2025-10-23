extends CharacterBody3D
class_name projectile

@export var speed: float = 10
var knockback : int
var damage : int

func _physics_process(delta: float) -> void:
	velocity = -get_global_transform().basis.z * speed * delta
	var collision = move_and_collide(velocity)
	
	if collision:
		queue_free()
