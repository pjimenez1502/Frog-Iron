extends Node3D
class_name RangedWeapon

var character_stats: CharacterStats
var character_animation: CharacterAnimation

@onready var projectile_container: Node = $ProjectileContainer
@export var projectile_prefab: PackedScene

var target_layer: Util.CollisionLayer
var weapon_data: WeaponResource

var knockback: int = 0

func setup(_weapon_data: WeaponResource, _character_stats: CharacterStats, _character_animation: CharacterAnimation) -> void:
	weapon_data = _weapon_data
	character_stats = _character_stats
	character_animation = _character_animation
	#character_animation.torso_state(item_data.torso_state)
	set_target_layer()

func attack(direction: Vector3) -> void:
	var calc_damage: int = weapon_data.calculate_damage(character_stats)
	var calc_hitchance: int = weapon_data.calculate_hitchance(character_stats)
	var calc_knockback: int = knockback
	
	spawn_projectile(calc_damage, calc_hitchance, calc_knockback, direction)

func spawn_projectile(calc_damage: int, calc_hitchance: int, calc_knockback: int, direction: Vector3) -> void:
	var projectile_instance : Projectile = projectile_prefab.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.global_transform.basis = global_transform.basis
	projectile_instance.global_position = global_position
	projectile_instance.look_at(global_position - direction)
	projectile_instance.setup_projectile(calc_damage, calc_hitchance, calc_knockback, target_layer)

func set_target_layer() -> void:
	match character_stats.character_tag:
		character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player
