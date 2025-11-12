extends Node

var POTION_POOL: Array[ConsumableResource]
#var GRENADE_POOL: Array[]
var WEAPON_POOL: Array[EquipableResource]
var ARMOR_POOL: Array[EquipableResource]
#var JEWELRY_POOL: Array[EquipableResource]
var SELLABLE_POOL: Array[ItemResource]

var category_weights: Array = [1,0,1,3,0,0]		##{ POTION, GRENADE, WEAPON, ARMOR, JEWELRY, LOOT }
var rarity_weights: Array = [16,8,4,2,1]		##{ COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, LOOT }
@onready var rng = RandomNumberGenerator.new()

func _ready() -> void:
	initialize_pools()

func generate_chest_loot(budget: int) -> Array[ItemResource]:
	var loot: Array[ItemResource]
	while budget > 0:
		var cost:int = rng.rand_weighted(rarity_weights)+1
		if cost > budget:
			continue
		match rng.rand_weighted(category_weights):
			Global.ItemCategory.POTION:
				loot.append(generate_potion(cost))
			Global.ItemCategory.GRENADE:
				loot.append(generate_grenade(cost))
			Global.ItemCategory.WEAPON:
				loot.append(generate_weapon(cost))
			Global.ItemCategory.ARMOR:
				loot.append(generate_armor(cost))
			Global.ItemCategory.JEWELRY:
				loot.append(generate_jewelry(cost))
			Global.ItemCategory.LOOT:
				loot.append(generate_loot(cost))
		
		budget -= cost
	return loot

func generate_potion(cost: int) -> ItemResource:
	var selected: ConsumableResource = POTION_POOL.pick_random()
	selected.rarity = cost -1 as Global.Rarity	## select rarity depending on budget
	return selected

func generate_grenade(cost: int) -> ItemResource:
	return null

func generate_weapon(cost: int) -> ItemResource:
	var selected: EquipableResource = WEAPON_POOL.pick_random()
	selected.rarity = cost -1 as Global.Rarity	## select rarity depending on budget
	#print("%s: %s, %d" % [selected.name, Global.Rarity.keys()[selected.rarity], selected.rarity])
	
	for i: int in selected.rarity:	## add statboosts depending on rarity
		var stat: String = selected.bonus_stats.keys().pick_random()
		selected.bonus_stats[stat] += 1
	selected.weapon_stats["DAMAGE"] += selected.rarity
	return selected

func generate_armor(cost: int) -> ItemResource:
	var selected: EquipableResource = ARMOR_POOL.pick_random()
	selected.rarity = cost -1 as Global.Rarity	## select rarity depending on budget
	#print("%s: %s, %d" % [selected.name, Global.Rarity.keys()[selected.rarity], selected.rarity])
	
	for i: int in selected.rarity:	## add statboosts depending on rarity
		print(i)
		var stat: String = selected.bonus_stats.keys().pick_random()
		selected.bonus_stats[stat] += 1
	return selected

func generate_jewelry(cost: int) -> ItemResource:
	return null

func generate_loot(cost: int) -> ItemResource:
	return null


func initialize_pools() -> void:
	initialize_consumables()
	initialize_weapons()
	initialize_armors()

func initialize_consumables() -> void:
	var potion_dir: String = "res://Data/Item/Consumable/"
	for resource: String in ResourceLoader.list_directory(potion_dir):
		var res = ResourceLoader.load(potion_dir + resource)
		if !(res is ConsumableResource):
			printerr("NOT CONSUMABLE RESOURCE: %s" % resource)
			continue
		POTION_POOL.append(res)

func initialize_weapons() -> void:
	var weapon_dirs: Array[String] = ["res://Data/Item/Equipable/Weapon/Melee/", "res://Data/Item/Equipable/Weapon/Ranged/"]
	for dir: String in weapon_dirs:
		for resource: String in ResourceLoader.list_directory(dir):
			var res = ResourceLoader.load(dir + resource)
			if !(res is EquipableResource):
				printerr("NOT WEAPON RESOURCE: %s" % resource)
				continue
			WEAPON_POOL.append(res)

func initialize_armors() -> void:
	var armor_dir: String = "res://Data/Item/Equipable/Armor/"
	for resource: String in ResourceLoader.list_directory(armor_dir):
		var res = ResourceLoader.load(armor_dir + resource)
		if !(res is EquipableResource):
			printerr("NOT ARMOR RESOURCE: %s" % resource)
			continue
		ARMOR_POOL.append(res)
	
