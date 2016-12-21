extends Node2D



const SHIP_HORIZONTAL_SPEED = 150
const SHIP_VERTICAL_SPEED = 150

const TILE_FUEL = 5

const FUEL_MAX = 100
const FUEL_LOSS_STEP = 0.1
const FUEL_REFUEL_STEP = 1

const LIVES_MAX = 3


var viewport_size

var score
var score_label
var fuel
var fuel_label
var lives
var lives_label

var tile_map

var ship
var is_refuel
var ship_texture_x
var center_image
var left_image
var right_image

var bullet



func _ready():
	viewport_size = get_viewport().get_rect().size
	score_label = get_node("hud/score")
	score = 0
	fuel_label = get_node("hud/fuel")
	fuel = FUEL_MAX
	lives = LIVES_MAX
	lives_label = get_node("hud/lives")

	tile_map = get_node("tile_map")

	ship = get_node("ship")
	fuel = FUEL_MAX
	is_refuel = false
	ship_texture_x = ship.get_node("sprite").get_texture().size.x / 2
	left_image = load('res://animation/ship/l0_Plane2.png')
	right_image = load('res://animation/ship/l0_Plane4.png')
	center_image = load('res://animation/ship/l0_Plane1.png')

	bullet = get_node("bullet")

	set_fixed_process(true)


func _fixed_process(delta):
	set_pos(get_game_pos(delta))
	process_ship(delta)


func process_ship(delta):
	if is_ship():
		ship.set_pos(get_ship_pos(delta))
		set_fuel()


func set_fuel():
	if is_refuel and fuel < FUEL_MAX - FUEL_REFUEL_STEP:
		fuel += FUEL_REFUEL_STEP

	fuel -= FUEL_LOSS_STEP

	fuel_label.set_text("FUEL: " + str(fuel))


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
	if body != tile_map:
		return

	if is_tile_fuel(get_tile_pos()):
		is_refuel = true
	else:
		destroy_ship()


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

	var image
	var ship_before_left_border = ship_pos.x - ship_texture_x > 0

	if (Input.is_action_pressed("ui_left") and ship_before_left_border):
		ship_pos.x += -SHIP_VERTICAL_SPEED * delta
		image = left_image

	var ship_before_right_border = ship_pos.x + ship_texture_x < viewport_size.x

	if (Input.is_action_pressed("ui_right") and ship_before_right_border):
		ship_pos.x += SHIP_VERTICAL_SPEED * delta
		image = right_image

	set_ship_sprite(image)

	return ship_pos


func set_ship_sprite(image):
	if image != left_image and image != right_image:
		image = center_image

	var sprite = ship.get_node("sprite")
	sprite.set_texture(image)


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


func set_score(points):
	score += points
	score_label.set_text("SCORE: " + str(score))


func destroy_ship():
	ship.queue_free()