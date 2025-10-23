extends Node3D

@onready var trap_spikes: Node3D = $TrapSpikes



func _on_trigger_area_body_entered(body: Node3D) -> void:
	print("S")
	if body is player:
		var tween = get_tree().create_tween()
		tween.tween_property(trap_spikes, "position", Vector3(0,0,0), 0.1)

func _on_hurt_area_body_exited(body: Node3D) -> void:
	if body is player:
		body.damage()
