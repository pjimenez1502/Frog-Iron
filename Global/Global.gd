extends Node

## ITEM AND INVENTORY
enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, LOOT }
var rarity_colors : Array[Color] = [
	Color(1.0, 1.0, 1.0, 1.0),
	Color(0.083, 1.0, 0.0, 1.0),
	Color(0.0, 0.7, 1.0, 1.0),
	Color(0.783, 0.0, 1.0, 1.0),
	Color(0.999, 0.568, 0.0, 1.0),
	Color(0.603, 0.29, 0.0, 1.0)]
var rarity_prefixes: Dictionary = {
	"METAL": {0: "Bronze", 1: "Iron", 2: "Steel", 3: "Mythril", 4: "Black Gold"},
	"LEATHER": {0: "Scrap Leather", 1: "Leather", 2: "Hard Hide", 3: "Mythril reinforced", 4: "DragonHide"},
	"CLOTH": {0: "Ragged", 1: "Cloth", 2: "Silk", 3: "Wax String", 4: "Soul Webbed"},
	"JEWELRY": {0: "Copper", 1: "Silver", 2: "Gold", 3: "Mythril", 4: "Black Gold"},
}

enum ItemCategory { POTION, GRENADE, WEAPON, ARMOR, JEWELRY, LOOT }
enum EquipSlot { RANGEDWEAPON, MELEEWEAPON, HEAD, TORSO, ARMS, LEGS }


## PLAYER LEVEL
const LEVEL_STATUP_REWARD: int = 2
const LEVEL_GROWTH_MULT: float = 0.3

#const INVUL_DURATION: float = 0.4

## BUDGETS
const CHEST_BUDGET: int = 4
const ENEMY_BUDGET_BASE: int = 20

const PLAYER_TURN_DURATION: float = 0.2
const ENEMY_TURN_DURATION: float = 0.1

## DUNGEON
const TILE_SIZE: int = 4


## STATS
const con_health_mult: int = 1
const dex_stamina_mult: int = 1
const wis_sanity_mult: int = 2
