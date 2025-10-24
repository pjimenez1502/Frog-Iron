extends NavigationRegion3D
class_name NavRegion

func _ready() -> void:
	SignalBus.NavmeshBakeRequest.connect(bake_navregion)

func bake_navregion() -> void:
	bake_navigation_mesh()
