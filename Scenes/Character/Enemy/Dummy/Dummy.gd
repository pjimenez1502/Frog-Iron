extends Character
class_name Dummy

func _ready() -> void:
	character_stats = null

func move(_delta: float) -> void:
	pass

func damage(_damage: int) -> void:
	print("Dummy damaged: ", _damage)
