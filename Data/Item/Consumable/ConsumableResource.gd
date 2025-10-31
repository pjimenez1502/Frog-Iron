extends ItemResource
class_name ConsumableResource

enum EFFECT { HEALTH, SHIELD, }
@export var effect: EFFECT

func consumable_effect(target: Character) -> void:
	match effect:
		EFFECT.HEALTH:
			target.character_stats.heal(8 + 8*rarity)
