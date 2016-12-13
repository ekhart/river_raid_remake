extends Node2D


const SHIP_HORIZONTAL_SPEED = 150
const SHIP_VERTICAL_SPEED = 150
const BULLET_SPEED = 300
const BULLET_Y_OFFSET = 50
const ENEMY_MAX_WIGGLE = 5
const ENEMY_VERTICAL_SPEED = 1


var ship
var bullet
var is_bullet
var enemy
var tile_map


func _ready():
	tile_map = get_node("TileMap")

	ship = get_node("ship")
	ship.connect("body_enter", self, "_on_ship_body_enter")

	bullet = get_node("bullet")
	bullet.hide()
	bullet.connect("body_enter", self, "_on_bullet_body_enter")
	bullet.connect("area_enter", self, "_on_bullet_area_enter")

	enemy = get_node("enemy")
	enemy.connect("body_enter", self, "_on_enemy_body_enter")
	enemy.connect("area_enter", self, "_on_enemy_area_enter")

	set_fixed_process(true)


func _fixed_process(delta):
	set_pos(get_game_pos(delta))

	if is_ship():
		ship.set_pos(get_ship_pos(delta))

	process_bullet(delta)
	process_enemy(delta)


func process_enemy(delta):
	if has_node("enemy"):
		var enemy_pos = enemy.get_pos()
		var tics = OS.get_ticks_msec()
		var x = tics % 100000 / 200
		enemy_pos.x += ENEMY_MAX_WIGGLE * cos(x)
		enemy_pos.y += ENEMY_VERTICAL_SPEED
		enemy.set_pos(enemy_pos)


func _on_enemy_body_enter(body):
	if body == tile_map:
		enemy.queue_free()


func _on_enemy_area_enter(body):
	if body == bullet and is_bullet:
		enemy.queue_free()

		bullet.hide()
		is_bullet = false

	if body == ship:
		ship.queue_free()


func _on_bullet_body_enter(body):
	if body == tile_map:
		bullet.hide()
		is_bullet = false


func _on_bullet_area_enter(body):
	_on_bullet_body_enter(body)


func process_bullet(delta):
	var bullet_pos = bullet.get_pos()

	if Input.is_action_pressed("ui_accept") and not is_bullet and has_node("ship"):
		var ship_pos = ship.get_pos()
		bullet_pos.x = ship_pos.x
		bullet_pos.y = ship_pos.y - BULLET_Y_OFFSET
		bullet.show()
		is_bullet = true

	if (bullet_pos.y < 0): # change to on screen exit
		bullet.hide()
		is_bullet = false

	if (bullet.is_visible()):
		bullet_pos.y += -BULLET_SPEED * delta
		bullet.set_pos(bullet_pos)


func _on_ship_body_enter(body):
	if body == tile_map:
		ship.queue_free()


func get_ship_pos(delta):
	if not is_ship():
		return

	var ship_pos = ship.get_pos()

	ship_pos.y -= SHIP_HORIZONTAL_SPEED * delta

	if (Input.is_action_pressed("ui_up")):
		ship_pos.y += -100 * delta

	if (Input.is_action_pressed("ui_down")):
		ship_pos.y += 100 * delta

	if (Input.is_action_pressed("ui_left")):
		ship_pos.x += -SHIP_VERTICAL_SPEED * delta

	if (Input.is_action_pressed("ui_right")):
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