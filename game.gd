extends Node2D



const FUEL_MAX = 100
const FUEL_LOSS_STEP = 0.1
const FUEL_REFUEL_STEP = 1
const FUEL_ALMOST_MAX = FUEL_MAX - FUEL_REFUEL_STEP

const LIVES_MAX = 3
const LIVES_STEP = 1
const LIVES_NEXT = 10000


var viewport_size

var score
var score_label
var fuel
var fuel_label
var lives
var lives_label
var is_refuel

var tile_map
var ship
var bullet
var last_bridge



func _ready():
	viewport_size = get_viewport().get_rect().size

	score = 0
	score_label = get_node("hud/score")
	fuel = FUEL_MAX
	fuel_label = get_node("hud/fuel")
	lives = LIVES_MAX
	lives_label = get_node("hud/lives")
	is_refuel = false

	tile_map = get_node("tile_map")
	ship = get_node("ship")
	bullet = get_node("bullet")

	set_fixed_process(true)


func _fixed_process(delta):
	set_pos(get_game_pos(delta))

	if is_ship():
		set_fuel()


func get_game_pos(delta):
	var pos = get_pos()

	pos.y += ship.SHIP_HORIZONTAL_SPEED * delta

	if (Input.is_action_pressed("ui_up")):
		pos.y += 100 * delta

	if (Input.is_action_pressed("ui_down")):
		pos.y += -100 * delta

	return pos


func is_ship():
	return has_node("ship")


func set_fuel():
	if is_refuel and fuel < FUEL_ALMOST_MAX:
		fuel += FUEL_REFUEL_STEP
		if fuel >= FUEL_ALMOST_MAX:
			ship.play_until_end("max_fuel")

	fuel -= FUEL_LOSS_STEP
	fuel_label.set_text("FUEL: " + str(fuel))
	ship.play_until_end("refuel", is_refuel)


func set_score(points):
	var last_score = score
	
	score += points
	score_label.set_text("SCORE: " + str(score))
	
	var last_mod = last_score % LIVES_NEXT
	var current_mod = score % LIVES_NEXT
	
	if last_mod > current_mod:
		set_lives(LIVES_STEP)


func set_lives(number = -LIVES_STEP):
	lives += number
	lives_label.set_text("LIVES: " + str(lives))
	
	if number == -LIVES_STEP:
		set_pos(Vector2(0, last_bridge.get_pos().y + 250))
		ship.set_global_pos(ship.START_POS) # reset ship position
		last_bridge.show()


func is_tile_fuel():
	var pos = tile_map.get_tile_pos(ship)
	return tile_map.is_tile_fuel(pos)
	
	
func on_bullet_bridge_area_enter(bridge):
	bullet.hide_bullet()
	set_score(bridge.SCORE)
	last_bridge = bridge