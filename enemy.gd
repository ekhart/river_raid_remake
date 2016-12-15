extends Area2D


const ENEMY_MAX_WIGGLE = 5
const ENEMY_VERTICAL_SPEED = 1
const SCORE_ENEMY = 100


var game


func _ready():
	game = get_parent().get_parent()


func _fixed_process(delta):
	var pos = get_pos()
	var tics = OS.get_ticks_msec()
	var x = tics % 100000 / 200
	pos.x += ENEMY_MAX_WIGGLE * cos(x)
	pos.y += ENEMY_VERTICAL_SPEED
	set_pos(pos)


func _on_visibility_enter_screen():
	set_fixed_process(true)


func _on_visibility_exit_screen():
	destroy()


func _on_enemy_body_enter(body):
	if body == game.tile_map:
		destroy()


func _on_enemy_area_enter(body):
	if game.bullet.is_bullet(body):
		destroy()

		game.bullet.hide_bullet()
		game.set_score(SCORE_ENEMY)

	if body == game.ship:
		game.destroy_ship()


func destroy():
	queue_free()
	set_fixed_process(false)