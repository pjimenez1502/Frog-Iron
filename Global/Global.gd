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
enum ItemCategory { POTION, GRENADE, WEAPON, ARMOR, JEWELRY, LOOT }
enum EquipSlot { RANGEDWEAPON, MELEEWEAPON, HEAD, TORSO, ARMS, LEGS }


## PLAYER LEVEL
const LEVEL_STATUP_REWARD: int = 2
const LEVEL_GROWTH_MULT: float = 0.3

const INVUL_DURATION: float = 0.4

const CHEST_BUDGET: int = 4

const PLAYER_TURN_DURATION: float = 0.2
const ENEMY_TURN_DURATION: float = 0.1

## DUNGEON
const TILE_SIZE: int = 4
