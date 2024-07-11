extends CharacterBody3D
class_name projectile

@export var speed: float = 10
var knockback : int
var damage : int

func _physics_process(delta: float) -> void:
	velocity = get_global_transform().basis.z * speed * delta
	var collision = move_and_collide(velocity)
	
	if collision:
		check_collision(collision.get_collider(), collision.get_position())

func check_collision(collision, point: Vector3) -> void:
	print(collision)
	if !"health" in collision:
		queue_free()
		return
	
	#if collision.health:
		##hit(collision)
		#set_physics_process(false)
		#queue_free()

#func hit(character: Character) -> void:
	#character.damage(damage)
	#character.set_knockback(velocity.normalized(), knockback)
