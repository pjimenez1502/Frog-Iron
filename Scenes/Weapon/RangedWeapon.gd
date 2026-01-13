extends Node3D
class_name RangedWeapon

var character_stats: CharacterStats
var character_animation: CharacterAnimation

#@onready var projectile_container: Node = $ProjectileContainer
#@export var projectile_prefab: PackedScene

var target_layer: Util.CollisionLayer
var weapon_data: GunResource

var knockback: int = 0

func setup(_weapon_data: GunResource, _character_stats: CharacterStats, _character_animation: CharacterAnimation) -> void:
	weapon_data = _weapon_data
	character_stats = _character_stats
	character_animation = _character_animation
	
	set_target_layer()

func attack(direction: Vector3) -> void:
	var calc_damage: int = weapon_data.calculate_damage(character_stats)
	var calc_hitchance: int = weapon_data.calculate_hitchance(character_stats)
	var calc_knockback: int = knockback
	
	#spawn_projectile(calc_damage, calc_hitchance, calc_knockback, direction)
	for shot: int in weapon_data.weapon_stats["SHOTS_PER_ACTION"]:
		var hits: Array[Node3D] = await shoot(direction)
		for hit: Node3D in hits:
			if hit is Character:
				hit.damage(calc_damage, calc_hitchance)

func shoot(direction: Vector3) -> Array[Node3D]:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var hits: Array[Node3D]
	for i: int in weapon_data.weapon_stats["PROJECTILES"]:
		var target_point: Vector3 = global_position + (direction*weapon_data.weapon_stats["RANGE"] * Global.TILE_SIZE) + Vector3(
			randf_range(-weapon_data.weapon_stats["SPREAD"], weapon_data.weapon_stats["SPREAD"]),
			randf_range(-weapon_data.weapon_stats["SPREAD"],weapon_data.weapon_stats["SPREAD"]) /2,
			randf_range(-weapon_data.weapon_stats["SPREAD"],weapon_data.weapon_stats["SPREAD"]))
		var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(global_position, target_point, target_layer)
		var intersect_data: Dictionary = space_state.intersect_ray(query)
		if intersect_data:
			hits.append(intersect_data.collider)
		
		await get_tree().create_timer(0.05).timeout
		#print("Shot: %s, %s" % [str(global_position), str(target_point)])
		DebugDraw3D.draw_line(global_position, target_point, Color.WHITE, .25)
	return hits

#func spawn_projectile(calc_damage: int, calc_hitchance: int, calc_knockback: int, direction: Vector3) -> void:
	#var projectile_instance : Projectile = projectile_prefab.instantiate()
	#projectile_container.add_child(projectile_instance)
	#projectile_instance.global_transform.basis = global_transform.basis
	#projectile_instance.global_position = global_position
	#projectile_instance.look_at(global_position - direction)
	#projectile_instance.setup_projectile(calc_damage, calc_hitchance, calc_knockback, target_layer)

func set_target_layer() -> void:
	match character_stats.character_tag:
		character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player
