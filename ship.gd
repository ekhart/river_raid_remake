extends Area2D

const SHIP_HORIZONTAL_SPEED = 150
const SHIP_VERTICAL_SPEED = 150
const START_POS = Vector2(500, 500)

var game

var ship_texture_x
var sprite
var center_image
var left_image
var right_image
var is_accelerate
var is_downturn
var timer 
var boom_animation
var boom_sfx


func _ready():
	game = get_parent()
	timer = get_node("timer")
	sprite = get_node("sprite")
	boom_animation = get_node("boom/animation")
	boom_sfx = get_node("boom_sfx")
	ship_texture_x = sprite.get_texture().size.x / 2
	left_image = load('res://animation/ship/l0_Plane2.png')
	right_image = load('res://animation/ship/l0_Plane4.png')
	center_image = load('res://animation/ship/l0_Plane1.png')
	is_accelerate = false
	is_downturn = false
	set_fixed_process(true)


func _fixed_process(delta):
	set_pos(get_ship_pos(delta))
	set_engine_samples()


func get_ship_pos(delta):
	var pos = get_pos()

	pos.y -= SHIP_HORIZONTAL_SPEED * delta

	if (Input.is_action_pressed("ui_up")):
		pos.y += -100 * delta
		is_accelerate = true

	if (Input.is_action_pressed("ui_down")):
		pos.y += 100 * delta
		is_downturn = true

	var image
	var ship_before_left_border = pos.x - ship_texture_x > 0

	if Input.is_action_pressed("ui_left") and ship_before_left_border:
		pos.x += -SHIP_VERTICAL_SPEED * delta
		image = left_image

	var ship_before_right_border = pos.x + ship_texture_x < game.viewport_size.x

	if Input.is_action_pressed("ui_right") and ship_before_right_border:
		pos.x += SHIP_VERTICAL_SPEED * delta
		image = right_image

	set_ship_sprite(image)

	return pos


func set_ship_sprite(image):
	if image != left_image and image != right_image:
		image = center_image

	sprite.set_texture(image)


func set_engine_samples():
	var engine = get_node("engine")
	var accelerate = get_node("accelerate")
	var downturn = get_node("downturn")
	
	if is_accelerate or is_downturn:
		engine.stop()
	
	if is_accelerate and not accelerate.is_active():
		accelerate.play("accelerate")

	if is_downturn and not downturn.is_active():
		downturn.play("downturn")
		
	if not accelerate.is_active() and not downturn.is_active() and not engine.is_playing():
		engine.play()
		
	is_accelerate = false
	is_downturn = false


func play_until_end(sample, is_true = true):
	var sample_node = get_node(sample)
	if is_true and not sample_node.is_active():
		sample_node.play(sample)


func _on_ship_body_enter(body):
	if body == game.tile_map:
		destroy()


func _on_ship_body_exit(body):
	if body == game.tile_map:
		game.is_refuel = false


func destroy():
	if game.lives > 0:
		sprite.hide()
		boom_animation.play("animation")
		boom_sfx.play("boom")
		timer.start()
	else:
		queue_free()


func _on_timer_timeout():
	boom_sfx.stop_all()
	boom_animation.stop_all()
	sprite.show()
	game.hud.set_lives()
	