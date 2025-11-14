extends Node
class_name CharacterAnimation

@onready var _3D_VIEW: Node3D = %"3D"
@onready var animation_tree: AnimationTree = %AnimationTree

func _ready() -> void:
	torso_state(TorsoState.Idle)

func movement_animation(_velocity: Vector3, direction: Vector3, _delta:float) -> void:
	animation_tree.set("parameters/WalkBlend/blend_position", _velocity.length())
	if !direction:
		return
	_3D_VIEW.rotation.y = lerp_angle(_3D_VIEW.rotation.y, atan2(direction.x, direction.z), _delta * 12)

enum TorsoState {Idle, Bow, Sword, GreatAxe}
func torso_state(state: TorsoState) -> void:
	animation_tree.set("parameters/Torso/transition_request", TorsoState.keys()[state])

func bow_draw(draw_value: float) -> void:
	animation_tree.set("parameters/BowDrawTime/seek_request", draw_value)
