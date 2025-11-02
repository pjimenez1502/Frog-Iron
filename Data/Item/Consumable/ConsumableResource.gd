extends ItemResource
class_name ConsumableResource

enum EFFECT { HEALTH, SHIELD, }
@export var effect: EFFECT

var heal_value: int = 4

func consumable_effect(target: Character) -> void:
	match effect:
		EFFECT.HEALTH:
			target.character_stats.heal(heal_value + heal_value*rarity)
