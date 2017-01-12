extends Node2D


var viewport_size

var hud
var tile_map
var ship
var bullet
var last_bridge

var is_refuel
var is_started

var reload

func _ready():
	viewport_size = get_viewport().get_rect().size
	hud = get_node("hud")
	tile_map = get_node("tile_map")
	ship = get_node("ship")
	bullet = get_node("bullet")
	last_bridge = get_node("bridges/bridge")
	reload = get_node("reload")
	set_process_input(true)
	
	
func _input(event):
	if not is_fixed_processing() and any_actions_released(event):
		start(true)
		hud.hide_splash()


func any_actions_released(event):
	var actions = ["ui_up", "ui_down", "ui_left", "ui_right", "ui_accept"]
	for action in actions:
		if event.is_action_released(action):
			return true
	return false


func start(is_start):
	set_fixed_process(is_start)
	if is_ship(): ship.set_fixed_process(is_start)
	bullet.set_fixed_process(is_start)


func _fixed_process(delta):
	if is_ship():
		set_pos(get_game_pos(delta))
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
	return has_node("ship") and ship.is_alive()


func on_bullet_bridge_area_enter(bridge):
	bullet.hide_bullet()
	hud.set_score(bridge.get_score())
	hud.set_bridge()
	last_bridge = bridge
	
	
func over():
	hud.show_over()
	start(false)
	reload.start()

func _on_reload_timeout():
	reload.stop()
	get_tree().reload_current_scene()
