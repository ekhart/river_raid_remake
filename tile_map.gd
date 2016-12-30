extends TileMap


const TILE_FUEL = 0


func dec(n):
	return n - 1


func inc(n):
	return n + 1


func is_tile_fuel(tile_pos):
	var search_tiles_poss = [
		Vector2(tile_pos.x, dec(tile_pos.y)),
		Vector2(tile_pos.x, tile_pos.y - 2),

		Vector2(dec(tile_pos.x), tile_pos.y),
		Vector2(dec(tile_pos.x), dec(tile_pos.y)),
		Vector2(dec(tile_pos.x), tile_pos.y - 2),

		Vector2(inc(tile_pos.x), tile_pos.y),
		Vector2(inc(tile_pos.x), dec(tile_pos.y)),
		Vector2(inc(tile_pos.x), tile_pos.y - 2)
	]

	for v in search_tiles_poss:
		var cell = get_cellv(v)
		if cell == TILE_FUEL:
			return true

	return false


func get_tile_pos(ship):
	return world_to_map(ship.get_pos())
