extends Node2D


const SCORE_ENEMY = 100
const SHIP_HORIZONTAL_SPEED = 150
const SHIP_VERTICAL_SPEED = 150
const BULLET_SPEED = 600
const BULLET_Y_OFFSET = 50
const ENEMY_MAX_WIGGLE = 5
const ENEMY_VERTICAL_SPEED = 1

const TILE_FUEL = 5


var viewport_size
var points
var score

var ship
var bullet
var is_bullet
var enemy
var tile_map


func _ready():
	viewport_size = get_viewport().get_rect().size
	score = get_node("hud/score")
	points = 0

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

		set_score(SCORE_ENEMY)

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

	if Input.is_action_pressed("ui_accept") and not is_bullet and is_ship():
		var ship_pos = ship.get_pos()
		bullet_pos.x = ship_pos.x
		bullet_pos.y = ship_pos.y - BULLET_Y_OFFSET
		bullet.show()
		is_bullet = true

	if (bullet.is_visible()):
		bullet_pos.y += -BULLET_SPEED * delta
		bullet.set_pos(bullet_pos)


func _on_ship_body_enter(body):
	if not body == tile_map:
		return
		
	var ship_pos = ship.get_pos()
	var tile_pos = tile_map.world_to_map(ship_pos)
	
	tile_pos.y -= 1
	var tile_upper = tile_map.get_cellv(tile_pos)
	tile_pos.y -= 1
	var tile_bottom = tile_map.get_cellv(tile_pos)

	if tile_upper == TILE_FUEL or tile_bottom == TILE_FUEL:
		pass
	else:
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
	bullet.hide()
	is_bullet = false


func set_score(point):
	points += point
	score.set_text("SCORE: " + str(points))