extends Node2D


var viewport_size
var hud
var is_refuel
var tile_map
var ship
var bullet
var last_bridge


func _ready():
	viewport_size = get_viewport().get_rect().size

	hud = get_node("hud")
	tile_map = get_node("tile_map")
	ship = get_node("ship")
	bullet = get_node("bullet")
	last_bridge = get_node("bridges/bridge")

	set_fixed_process(true)


func _fixed_process(delta):
	set_pos(get_game_pos(delta))

	if is_ship():
		hud.set_fuel()


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


func on_bullet_bridge_area_enter(bridge):
	bullet.hide_bullet()
	hud.set_score(bridge.SCORE)
	hud.set_bridge()
	last_bridge = bridge