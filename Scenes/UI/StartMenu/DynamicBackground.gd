extends Control


var center : Vector2

func _ready() -> void:
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)

func _process(delta: float) -> void:
	var offset : Vector2 = center - Vector2( clamp(get_global_mouse_position().x, 0, get_viewport_rect().size.x), clamp(get_global_mouse_position().y, 0, get_viewport_rect().size.y)) * 0.2
	position = lerp(position, offset, delta)
	#print(clamp(get_global_mouse_position(), Vector2.ZERO, get_viewport_rect().size), " -- ", get_global_mouse_position())
