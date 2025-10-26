extends WeaponHit
class_name WeaponHitTemp

@export var duration: float = 0.2

func _ready() -> void:
	super._ready()
	var tween: Tween = get_tree().create_tween()
	await tween.tween_property($Sprite3D, "modulate:a", 0, duration).finished
	queue_free()
