extends Node2D



const FUEL_MAX = 100
const FUEL_LOSS_STEP = 0.1
const FUEL_REFUEL_STEP = 1
const ALMOST_FUEL_MAX = FUEL_MAX - FUEL_REFUEL_STEP

const LIVES_MAX = 3


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
	if is_refuel and fuel < ALMOST_FUEL_MAX:
		fuel += FUEL_REFUEL_STEP
		if fuel >= ALMOST_FUEL_MAX:
			ship.play_until_end("max_fuel")

	fuel -= FUEL_LOSS_STEP
	fuel_label.set_text("FUEL: " + str(fuel))
	ship.play_until_end("refuel", is_refuel)


func set_score(points):
	score += points
	score_label.set_text("SCORE: " + str(score))


func set_lives():
	lives -= 1
	lives_label.set_text("LIVES: " + str(lives))
	# get_tree().reload_current_scene()
	
	var bridge_pos = last_bridge.get_pos()
	var ship_pos = ship.get_pos()
	var game_pos = get_pos()
	
	var bridge_global_pos = last_bridge.get_global_pos()
	var ship_global_pos = ship.get_global_pos()
	var game_global_pos = get_global_pos()
	
	set_global_pos(Vector2(0, bridge_global_pos.y - 500))
	
	bridge_global_pos.y -= 300
	ship.set_global_pos(bridge_global_pos)
	last_bridge.show()


func is_tile_fuel():
	var pos = tile_map.get_tile_pos(ship)
	return tile_map.is_tile_fuel(pos)