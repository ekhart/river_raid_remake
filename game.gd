extends Node2D


const SHIP_HORIZONTAL_SPEED = 150
const SHIP_VERTICAL_SPEED = 150
const BULLET_SPEED = 600
const BULLET_Y_OFFSET = 50

const TILE_FUEL = 5

const FUEL_MAX = 100
const FUEL_LOSS_STEP = 0.1
const FUEL_REFUEL_STEP = 1


var viewport_size

var score
var score_label
var fuel
var fuel_label

var tile_map

var ship
var is_refuel

var bullet
var is_bullet



func _ready():
	viewport_size = get_viewport().get_rect().size
	score_label = get_node("hud/score")
	score = 0
	fuel_label = get_node("hud/fuel")
	fuel = 100

	tile_map = get_node("TileMap")

	ship = get_node("ship")
	fuel = FUEL_MAX
	is_refuel = false

	bullet = get_node("bullet")
	bullet.hide()

	set_fixed_process(true)


func _fixed_process(delta):
	set_pos(get_game_pos(delta))

	process_ship(delta)
	process_bullet(delta)


func process_ship(delta):
	if is_ship():
		ship.set_pos(get_ship_pos(delta))

		if is_refuel and fuel < FUEL_MAX - FUEL_REFUEL_STEP:
			fuel += FUEL_REFUEL_STEP

		fuel -= FUEL_LOSS_STEP

		fuel_label.set_text("FUEL: " + str(fuel))


func _on_bullet_body_enter(body):
	if body == tile_map:
		hide_bullet()


func _on_bullet_area_enter(body):
	_on_bullet_body_enter(body)


func process_bullet(delta):
	var bullet_pos = bullet.get_pos()

	if Input.is_action_pressed("ui_accept") and not is_bullet and is_ship():
		var ship_pos = ship.get_pos()
		bullet_pos.x = ship_pos.x
		bullet_pos.y = ship_pos.y - BULLET_Y_OFFSET
		bullet.show()
		is_bullet = true

	if (bullet.is_visible()):
		bullet_pos.y += -BULLET_SPEED * delta
		bullet.set_pos(bullet_pos)


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
		var cell = tile_map.get_cellv(v)

		if cell == TILE_FUEL:
			return true

	return false


func get_tile_pos():
	var ship_pos = ship.get_pos()
	return tile_map.world_to_map(ship_pos)


func _on_ship_body_enter(body):
	if not body == tile_map:
		return

	if is_tile_fuel(get_tile_pos()):
		is_refuel = true
	else:
		ship.queue_free()


func _on_ship_body_exit(body):
	if body == tile_map:
		is_refuel = false


func get_ship_pos(delta):
	if not is_ship():
		return

	var ship_pos = ship.get_pos()

	ship_pos.y -= SHIP_HORIZONTAL_SPEED * delta

	if (Input.is_action_pressed("ui_up")):
		ship_pos.y += -100 * delta

	if (Input.is_action_pressed("ui_down")):
		ship_pos.y += 100 * delta

	var ship_texture_x = ship.get_node("sprite").get_texture().size.x / 2
	var ship_before_left_border = ship_pos.x - ship_texture_x > 0

	if (Input.is_action_pressed("ui_left") and ship_before_left_border):
		ship_pos.x += -SHIP_VERTICAL_SPEED * delta

	var ship_before_right_border = ship_pos.x + ship_texture_x < viewport_size.x

	if (Input.is_action_pressed("ui_right") and ship_before_right_border):
		ship_pos.x += SHIP_VERTICAL_SPEED * delta

	return ship_pos


func is_ship():
	return has_node("ship")


func get_game_pos(delta):
	var pos = get_pos()

	pos.y += SHIP_HORIZONTAL_SPEED * delta

	if (Input.is_action_pressed("ui_up")):
		pos.y += 100 * delta

	if (Input.is_action_pressed("ui_down")):
		pos.y += -100 * delta

	return pos


func _on_bullet_exit_screen():
	hide_bullet()


func set_score(points):
	score += points
	score_label.set_text("SCORE: " + str(score))


func is_collision_with_bullet(body):
	return body == bullet and is_bullet


func hide_bullet():
	bullet.hide()
	is_bullet = false


func destroy_ship():
	ship.queue_free()