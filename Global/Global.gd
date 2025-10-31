extends Node

## ITEM AND INVENTORY
enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }
var rarity_colors : Array[Color] = [
	Color(1.0, 1.0, 1.0, 1.0),
	Color(0.083, 1.0, 0.0, 1.0),
	Color(0.0, 0.7, 1.0, 1.0),
	Color(0.783, 0.0, 1.0, 1.0),
	Color(0.999, 0.568, 0.0, 1.0),]
enum ItemCategory { POTION, GRENADE, ARMOR, JEWELRY, LOOT }
enum EquipSlot { WEAPON, HEAD, TORSO, ARMS, LEGS }



## PLAYER LEVEL
var LEVEL_STATUP_REWARD: int = 2
var LEVEL_GROWTH_MULT: float = 0.3

var INVUL_DURATION: float = 0.4
