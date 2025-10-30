extends Control
class_name EmergentInventoryView

func _ready() -> void:
	SignalBus.OpenEmergentInv.conect()

func populate_inv() -> void:
	pass
