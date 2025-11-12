extends ItemResource
class_name ConsumableResource

enum EFFECT { HEALTH, SHIELD, }
@export var effect: EFFECT


func consumable_effect(target: Character) -> void:
	match effect:
		EFFECT.HEALTH:
			target.character_stats.heal(HEAL_BASE + HEAL_BASE*rarity)


const HEAL_BASE: int = 4
