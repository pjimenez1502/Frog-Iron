extends Node3D
class_name RangedWeapon

var character: Character

#@onready var projectile_container: Node = $ProjectileContainer
#@export var projectile_prefab: PackedScene

var target_layer: Util.CollisionLayer
var weapon_data: GunResource

var knockback: int = 0
var current_magazine: int = 0

func setup(_weapon_data: GunResource, _character: Character) -> void:
	weapon_data = _weapon_data
	character = _character
	
	current_magazine = weapon_data.weapon_stats["MAGAZINE"]
	update_weapon_status()
	set_target_layer()

func attack(direction: Vector3) -> void:
	var calc_damage: int = weapon_data.calculate_damage(character.character_stats)
	var calc_hitchance: int = weapon_data.calculate_hitchance(character.character_stats)
	var calc_knockback: int = knockback
	
	#spawn_projectile(calc_damage, calc_hitchance, calc_knockback, direction)
	for shot: int in weapon_data.weapon_stats["SHOTS_PER_ACTION"]:
		if current_magazine > 0: current_magazine -= 1
		else:
			SignalBus.DamageText.emit("Magazine Empty!", character, DamageTextOverlay.TYPE.MESSAGE, DamageTextOverlay.SIZE.SMALL)
			return
		update_weapon_status()
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

func update_weapon_status() -> void:
	SignalBus.PlayerWeaponRangedUpdate.emit({
		"name": weapon_data.name,
		"current_mag": current_magazine,
		"max_mag":  weapon_data.weapon_stats["MAGAZINE"],
		"ammocount": character.character_inventory.get_remaining_ammo(weapon_data.ammo_type),})

#func spawn_projectile(calc_damage: int, calc_hitchance: int, calc_knockback: int, direction: Vector3) -> void:
	#var projectile_instance : Projectile = projectile_prefab.instantiate()
	#projectile_container.add_child(projectile_instance)
	#projectile_instance.global_transform.basis = global_transform.basis
	#projectile_instance.global_position = global_position
	#projectile_instance.look_at(global_position - direction)
	#projectile_instance.setup_projectile(calc_damage, calc_hitchance, calc_knockback, target_layer)

func set_target_layer() -> void:
	match character.character_stats.character_tag:
		character.character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character.character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player
