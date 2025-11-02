extends Node3D
class_name RangedWeapon

@export var enabled: bool
var character_stats: CharacterStats

@onready var sprite: AnimatedSprite3D = $Sprite
@onready var projectile_container: Node = $ProjectileContainer

@export var projectile_prefab: PackedScene
@export var aim_speed: float = 3 ##Rotation Speed

@export var charged: bool

var target_layer: Util.CollisionLayer
@export_group("Damage")
@export var base_damage: int = 2
@export var STR_mod: float = .0
@export var DEX_mod: float = .5
@export var INT_mod: float = .0
@export var knockback: int = 1

func _ready() -> void:
	if !charged:
		attack_timer.wait_time = cooldown

func equipped(_character_stats: CharacterStats) -> void:
	character_stats = _character_stats
	set_target_layer()

func pressed(_delta: float) -> void:
	if !charged:
		direct_shot()
		return
	charge_shot(_delta)
func released() -> void:
	if charged:
		release_charged_shot()


## DIRECT
@export_group("Direct")
@onready var attack_timer: Timer = %AttackTimer
@export var cooldown: float = 0.6
var attack_ready: bool = true

func direct_shot() -> void:
	if !attack_ready:
		return
	attack_ready = false
	attack_timer.start()
	shoot()

## CHARGED
@export_group("Charged")
@export var charge_time: float = 1
@export var min_charge: float = 0.4
var current_charge_time: float
var charge: float
func charge_shot(_delta: float)->void:
	current_charge_time = snapped(clampf(current_charge_time+_delta, 0, charge_time), 0.01)
	charge = current_charge_time / charge_time
	sprite.play(str("drawn_", int(charge*4)))

func release_charged_shot() -> void:
	current_charge_time = 0
	if charge < min_charge:
		return
	shoot(charge)
	sprite.play("drawn_0")

func shoot(strength: float=1) -> void:
	#print("Shot Charge: ", charge)
	var calc_damage: int = (base_damage + (STR_mod * character_stats.STR) + (DEX_mod * character_stats.DEX) + (INT_mod * character_stats.INT)) * strength
	var calc_knockback: int = knockback
	spawn_projectile(calc_damage, calc_knockback, strength)


var target_rotation : float
func rotate_weapon(target_pos: Vector3, delta:float) -> void:
	global_transform = global_transform.interpolate_with(global_transform.looking_at(target_pos), delta * aim_speed)

func spawn_projectile(damage: int, calc_knockback: int, strength: float) -> void:
	var projectile_instance : Projectile = projectile_prefab.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.global_transform.basis = global_transform.basis
	projectile_instance.global_position = global_position 
	projectile_instance.setup_projectile(damage, calc_knockback, strength, target_layer)

func _on_attack_timer_timeout() -> void:
	attack_ready = true

func set_target_layer() -> void:
	match character_stats.character_tag:
		character_stats.CHAR_TAG.PLAYER:
			target_layer = Util.CollisionLayer.Enemy
		character_stats.CHAR_TAG.ENEMY:
			target_layer = Util.CollisionLayer.Player
