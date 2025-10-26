extends Character
class_name Dummy

func _ready() -> void:
	animation_player = null
	sprite = null
	character_stats = null

func move() -> void:
	pass

func damage(damage: int) -> void:
	print("Dummy damaged: ", damage)
