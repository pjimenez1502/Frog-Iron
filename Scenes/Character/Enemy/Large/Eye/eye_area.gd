extends Node3D
class_name area_attack



func _on_area_body_entered(body: Node3D) -> void:
	body.damage()

func free() -> void:
	queue_free()
