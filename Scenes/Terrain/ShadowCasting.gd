extends Node
class_name ShadowCasting

var TILE_DICTIONARY: Dictionary
var map_size: Vector2i

var seen_tiles: Array
const MAX_VISION_DISTANCE: int = 6

func init_shadowcasting(tile_dictionary: Dictionary, _map_size: Vector2i) -> void:
	TILE_DICTIONARY = tile_dictionary
	map_size = _map_size

func update_fov(player_pos: Vector2i) -> void:
	##  --- Reset all visible tiles to seen
	shadow_seen_tiles()
	compute_fov(player_pos)

func compute_fov(origin: Vector2i) -> void:
	mark_visible(origin)
	for i: int in 4:
		var quadrant: Quadrant = Quadrant.new(i, origin)
		var first_row: Row = Row.new(1, -1, 1)
		scan(first_row, quadrant)

func reveal(tile : Vector2, quadrant : Quadrant) -> void:
	var result: Vector2i = quadrant.transform(tile)
	mark_visible(result)

func mark_visible(tile: Vector2i) -> void:
	seen_tiles.append(tile)
	var map_tile: MapTile = get_tile(tile)
	if !map_tile: return
	map_tile.update_visibility(LevelMap.VISIBILITY.VISIBLE)

func shadow_seen_tiles() -> void:
	for tile: Vector2i in seen_tiles:
		var map_tile: MapTile = get_tile(tile)
		if !map_tile: return
		map_tile.update_visibility(LevelMap.VISIBILITY.SEEN)

func get_tile(tile: Vector2i) -> MapTile:
	if tile.x < 0 or tile.y < 0: return null
	if tile.x > map_size.x-1 or tile.y > map_size.y-1: return null

	return TILE_DICTIONARY[tile]

# Checks if tile exists and a vision blocker
func is_wall(tile: Vector2i, quadrant : Quadrant) -> bool:
	if tile == Vector2i(-111,-111): return false
	var result: Vector2i = quadrant.transform(tile)
	return is_blocking(result)
# Checks if tile exists and NOT a vision blocker
func is_floor(tile: Vector2i, quadrant : Quadrant) -> bool:
	if tile == Vector2i(-111,-111): return false
	var result: Vector2i = quadrant.transform(tile)
	return not is_blocking(result)
# Checks if tile is a vision blocker
func is_blocking(tile : Vector2i) -> bool:
	var map_tile: MapTile = get_tile(tile)
	if !map_tile: return false
	return map_tile.blocks_vision

# Calculates the slope between the origin and a given tile, used to determine vision angles.
func slope(tile : Vector2i) -> float:
	var row_depth: int = tile.x
	var col: int = tile.y
	return (2.0 * col - 1.0) / (2.0 * row_depth)

# Determines if a tile falls symmetrically within the range of a given row for shadow casting.
func is_symmetric(row : Row, tile : Vector2) -> bool:
	var col: int = tile.y
	return col >= row.depth * row.start_slope and col <= row.depth * row.end_slope

func scan(row: Row, quadrant: Quadrant) -> void:
	if row.depth > MAX_VISION_DISTANCE:
		return
	var prev_tile: Vector2i = Vector2i(-111,-111)
	for tile: Vector2i in row.tiles():
		if is_wall(tile, quadrant) or is_symmetric(row, tile):
			reveal(tile, quadrant)
		if is_wall(prev_tile, quadrant) and is_floor(tile, quadrant):
			row.start_slope = slope(tile)
		if is_floor(prev_tile, quadrant) and is_wall(tile, quadrant):
			var next_row: Row = row.next()
			next_row.end_slope = slope(tile)
			scan(next_row, quadrant)
		prev_tile = tile
	if is_floor(prev_tile, quadrant):
		scan(row.next(), quadrant)



class Quadrant:
	var cardinal: int
	var ox: int
	var oy: int
	
	func _init(_cardinal: int, origin: Vector2i) -> void:
		cardinal = _cardinal
		ox = origin.x
		oy = origin.y
	
	## Transform a position relative to current quadrant to an absolute in the grid
	func transform(tile: Vector2i) -> Vector2i:
		var row: int = tile.x
		var col: int = tile.y
		match cardinal:
			0:
				return Vector2(ox + col, oy - row)
			1:
				return Vector2(ox + row, oy + col)
			2:
				return Vector2(ox + col, oy + row)
			3:
				return Vector2(ox - row, oy + col)
		return Vector2i(-111,-111)

class Row:
	var depth: int
	var start_slope: float
	var end_slope: float
	
	func _init(_depth : int, _start_slope: float, _end_slope: float) -> void:
		depth = _depth
		start_slope = _start_slope
		end_slope = _end_slope
	
	# Returns the tiles within the row that need to be scanned.
	func tiles() -> Array:
		var min_col: float = round_ties_up(self.depth * self.start_slope)
		var max_col: float = round_ties_down(self.depth * self.end_slope)
		var result: Array = []
		for i in range(min_col, min(max_col + 1, MAX_VISION_DISTANCE)):
			result.append(Vector2i(self.depth, i))
		return result

	# Gets the next row in sequence for the shadow casting process.
	func next() -> Row:
		return Row.new(self.depth + 1, self.start_slope, self.end_slope)
	
	# Utility functions for rounding numbers.
	func round_ties_up(n: int) -> float:
		return floor(n + 0.5)

	func round_ties_down(n: int) -> float:
		return ceil(n - 0.5)
