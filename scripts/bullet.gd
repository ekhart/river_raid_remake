extends Area2D


const BULLET_SPEED = 600
const BULLET_Y_OFFSET = 50


var is_bullet
var animate
var game


func _ready():
	game = get_parent()
	animate = get_node("sprite/animate")
	hide_bullet()
	set_fixed_process(true)


func _fixed_process(delta):
	var pos = get_pos()

	if Input.is_action_pressed("ui_accept") and not is_bullet and game.is_ship():
		var ship_pos = game.ship.get_pos()
		pos.x = ship_pos.x
		pos.y = ship_pos.y - BULLET_Y_OFFSET
		show()
		is_bullet = true
		get_node("sfx").play("shoot")
		animate.set_active(true)
		animate.play("animate")
		

	if (is_visible()):
		pos.y += -BULLET_SPEED * delta
		set_pos(pos)


func _on_visibility_exit_screen():
	hide_bullet()


func _on_bullet_area_enter(body):
	_on_bullet_body_enter(body)


func _on_bullet_body_enter(body):
	if body == game.tile_map:
		hide_bullet()


func hide_bullet():
	hide()
	is_bullet = false
	animate.set_active(false)
	animate.stop_all()


func is_bullet(body):
	return body == self and is_bullet