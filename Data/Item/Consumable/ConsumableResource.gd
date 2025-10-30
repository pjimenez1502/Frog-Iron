extends ItemResource
class_name ConsumableResource

enum EFFECT { HEALTH, SHIELD, }
@export var effect: EFFECT

func on_use() -> void:
	pass
