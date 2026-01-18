extends Panel
class_name AmmoPouchView

@onready var ammo_type: RichTextLabel = %AmmoType
@onready var content: RichTextLabel = %Content
@onready var capacity: RichTextLabel = %Capacity

func update_pouch(pouch_data: Dictionary) -> void:
	content.text = "%d" % pouch_data["content"]
	capacity.text = "[color=gray]%d" % pouch_data["capacity"]
	ammo_type.text = ""
	
	if pouch_data["content"] == 0:
		return
	match pouch_data["type"]:
		GunResource.AMMO_TYPES.LIGHT:
			ammo_type.text = "[color=orange]Light"
		GunResource.AMMO_TYPES.HEAVY:
			ammo_type.text = "[color=darkgreen]Heavy"
		GunResource.AMMO_TYPES.SLUG:
			ammo_type.text = "[color=red]Slug"
		_:
			ammo_type.text = "[color=gray]??"
