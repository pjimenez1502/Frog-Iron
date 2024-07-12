extends GridMap

var current_z = 6
var fall_timer = Timer
func _ready() -> void:
	start_timer()

func start_timer():
	fall_timer = Timer.new()
	add_child(fall_timer)
	fall_timer.timeout.connect(remove_from_current_row)
	fall_timer.start(.08)
	
var removed_from_row = []
func remove_from_current_row():
	if removed_from_row.size() == 12:
		removed_from_row = []
		current_z -= 1
	
	var pos: Vector3
	while true:
		var x = randi_range(-6,6)
		pos = Vector3(x, 0, current_z)
		if !removed_from_row.has(x):
			removed_from_row.append(x)
			break
	print(removed_from_row)
	remove_cell(pos)
	fall_timer.start()


func remove_cell(pos: Vector3i) -> void:
	set_cell_item(pos, INVALID_CELL_ITEM)
	##Instantiate falling floor in position
