extends Interaction
class_name LadderInteraction

enum DIRECTION { UP, DOWN }
@export var direction: DIRECTION

func interact() -> void:
	match direction:
		DIRECTION.UP:
			ladder_up()
		DIRECTION.DOWN:
			ladder_down()

func interact_valued(value: bool) -> void:
	pass

func ladder_up() -> void:
	print("LADDER UP")

func ladder_down() -> void:
	print("LADDER DOWN")
