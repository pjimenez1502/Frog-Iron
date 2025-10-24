extends Interaction
class_name LeverInteraction

@onready var lever: Lever_IntObject = $".."
@onready var hinge: Node3D = %Hinge
@export var target_opening: int = 45
@export var opening_time: float = 0.5

var on: bool

func _ready() -> void:
	swing_lever(on)

func lever_interaction(value: bool) -> void:
	if !lever.connected_interaction:
		printerr("Lever has no connected interaction")
		return
	swing_lever(value)
	lever.connected_interaction.interact_valued(value)

func swing_lever(value: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(hinge, "rotation_degrees", Vector3(0, 0, target_opening if value else -target_opening), opening_time).set_trans(Tween.TRANS_BOUNCE)
	await tween.finished

func interact() -> void:
	on = !on
	lever_interaction(on)
func interact_valued(value: bool) -> void:
	lever_interaction(value)
