extends WeaponHit
class_name WeaponHitTemp

var time: float = 0.6

func _ready() -> void:
	super._ready()
	var tween: Tween = create_tween()
	await tween.tween_property($Sprite3D, "modulate:a", 0, time).finished
	queue_free()
