extends Node3D
class_name RangedWeapon

var character_stats: CharacterStats
var character_animation: CharacterAnimation

@onready var projectile_container: Node = $ProjectileContainer
@export var projectile_prefab: PackedScene

@export var aim_speed: float = 3 ##Rotation Speed
@export var charged: bool

var target_layer: Util.CollisionLayer
@export_group("Damage")
var base_damage: int = 0
var damage_scaling: Dictionary
var knockback: int = 0


func setup(item_data: EquipableResource, _character_stats: CharacterStats, _character_animation: CharacterAnimation) -> void:
	base_damage = item_data.weapon_stats["DAMAGE"]
	knockback = item_data.weapon_stats["KNOCKBACK"]
	damage_scaling = item_data.damage_scaling
	character_stats = _character_stats
	character_animation = _character_animation
	#character_animation.torso_state(item_data.torso_state)
	set_target_layer()

func attack(direction: Vector3) -> void:
	var calculated_stats = character_stats.calculate_stats()
	var calc_damage: int = (base_damage + 
	(damage_scaling["STR"] * calculated_stats["STR"]) + 
	(damage_scaling["DEX"] * calculated_stats["DEX"]) + 
	(damage_scaling["INT"] * calculated_stats["INT"]) +
	(damage_scaling["WIS"] * calculated_stats["WIS"]) +
	(damage_scaling["CON"] * calculated_stats["CON"]))
	
	var calc_knockback: int = knockback
	spawn_projectile(calc_damage, calc_knockback, direction)


func spawn_projectile(damage: int, calc_knockback: int, direction: Vector3) -> void:
	var projectile_instance : Projectile = projectile_prefab.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.global_transform.basis = global_transform.basis
	projectile_instance.global_position = global_position
	projectile_instance.look_at(global_position - direction)
	projectile_instance.setup_projectile(damage, calc_knockback, target_layer)

func set_target_layer() -> void:
	match character_stats.character_tag:
		character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player
