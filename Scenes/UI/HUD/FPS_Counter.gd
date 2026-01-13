extends RichTextLabel


func _physics_process(_delta: float) -> void:
	text = "FPS: %d" % [Engine.get_frames_per_second()]
