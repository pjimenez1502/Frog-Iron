extends Node
class_name CharacterAttack

const UNARMED = preload("uid://bdntcukq7he2r")
@onready var character: Character = $".."

@export var weapon_attatchment: WeaponAttachment
@export var melee_weapon_data: EquipableResource
@export var ranged_weapon_data: EquipableResource

var melee_weapon: MeleeWeapon
var ranged_weapon: RangedWeapon

var attack_target: Character
var attack_available: bool = true

func _ready() -> void:
	setup_weapons()

func setup_weapons() -> void:
	if melee_weapon:
		melee_weapon.queue_free()
	if ranged_weapon:
		ranged_weapon.queue_free()
	
	if melee_weapon_data:
		var melee: MeleeWeapon = melee_weapon_data.scene.instantiate()
		weapon_attatchment.add_child(melee)
		melee_weapon = melee
		melee.setup(melee_weapon_data, %CharacterStats, %CharacterAnimation)
	else:
		melee_weapon_data = UNARMED
		setup_weapons()
		
	if ranged_weapon_data:
		var ranged: RangedWeapon = ranged_weapon_data.scene.instantiate()
		ranged_weapon = ranged
		weapon_attatchment.add_child(ranged)
		ranged.setup(ranged_weapon_data, %CharacterStats, %CharacterAnimation)
	else:
		ranged_weapon_data = null

func melee_attack(direction: Vector2i) -> void:
	if !melee_weapon:
		print("NO MELEE WEAPON EQUIPPED")
		return
	
	if !melee_weapon.weapon_data.stamina_cost <= character.character_stats.current_stamina:
		SignalBus.DamageText.emit("Too Exhausted!", character, DamageTextOverlay.TYPE.MESSAGE, DamageTextOverlay.SIZE.SMALL)
		return
	melee_weapon.attack(character.character_grid_movement.grid_position + direction)
	character.character_stats.change_stamina(-melee_weapon.weapon_data.stamina_cost)

func ranged_attack(direction: Vector3) -> void:
	if !ranged_weapon:
		print("NO RANGED WEAPON EQUIPPED")
		return
	
	if !ranged_weapon.weapon_data.stamina_cost <= character.character_stats.current_stamina:
		SignalBus.DamageText.emit("Too Exhausted!", character, DamageTextOverlay.TYPE.MESSAGE, DamageTextOverlay.SIZE.SMALL)
		return
	ranged_weapon.attack(direction)
	character.character_stats.change_stamina(-ranged_weapon.weapon_data.stamina_cost)



func dir_to_target(target: Character) -> Vector3:
	return (target.global_position - character.global_position).normalized()
