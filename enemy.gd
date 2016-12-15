extends Area2D


const ENEMY_MAX_WIGGLE = 5
const ENEMY_VERTICAL_SPEED = 1
const SCORE_ENEMY = 100


var tile_map
var bullet
var is_bullet
var ship


func _ready():
	tile_map = get_parent().get_node("TileMap")
	bullet = get_parent().get_node("bullet")
	ship = get_parent().get_node("ship")
	set_fixed_process(true)


func _fixed_process(delta):
	var pos = get_pos()
	var tics = OS.get_ticks_msec()
	var x = tics % 100000 / 200
	pos.x += ENEMY_MAX_WIGGLE * cos(x)
	pos.y += ENEMY_VERTICAL_SPEED
	set_pos(pos)


func _on_enemy_body_enter(body):
	if body == tile_map:
		destroy()


func _on_enemy_area_enter(body):
	if body == bullet and get_parent().is_bullet:
		destroy()

		bullet.hide()
		get_parent().is_bullet = false

		get_parent().set_score(SCORE_ENEMY)

	if body == ship:
		ship.queue_free()


func destroy():
	queue_free()
	set_fixed_process(false)




