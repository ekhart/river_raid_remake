extends Area2D


const ENEMY_MAX_WIGGLE = 5
const ENEMY_VERTICAL_SPEED = 1
const SCORE_ENEMY = 50
const CALL_BASE_FIXED_PROCESS = true


var game
var last_x
var start_wiggle_offset


func _ready():
	game = get_parent().get_parent()
	start_wiggle_offset = randi() * 10000 + 1


func _fixed_process(delta):
	if not CALL_BASE_FIXED_PROCESS:
		return 

	var pos = get_pos()
	last_x = pos.x

	var tics = OS.get_ticks_msec()
	var x = (tics + start_wiggle_offset) % 100000 / 200
	pos.x += ENEMY_MAX_WIGGLE * cos(x)
	pos.y += ENEMY_VERTICAL_SPEED
	set_pos(pos)

	set_enemy_scale(pos)


func set_enemy_scale(pos):
	var scale_x = 1
	if pos.x >= last_x:
		scale_x = 1
	else:
		scale_x = -1

	set_scale(Vector2(scale_x, 1))


func _on_visibility_enter_screen():
	play_sprite_move()
	set_fixed_process(true)
	
	
func play_sprite_move():
	var sprite_move = "sprite/move"
	if has_node(sprite_move):
		get_node(sprite_move).play("move")


func _on_visibility_exit_screen():
	queue_free()


func _on_enemy_body_enter(body):
	if body == game.tile_map:
		destroy()


func _on_enemy_area_enter(body):
	if game.bullet.is_bullet(body):
		destroy()

		game.bullet.hide_bullet()
		game.hud.set_score(SCORE_ENEMY)

	if body == game.ship:
		game.ship.destroy()


func destroy():
	get_node("sprite").hide()
	get_node("boom").show()
	get_node("boom/animation").play("animation")
	get_node("boom_sfx").play("boom")
	disconnect("area_enter", self, "_on_enemy_area_enter")
	disconnect("body_enter", self, "_on_enemy_body_enter")
	set_fixed_process(false)