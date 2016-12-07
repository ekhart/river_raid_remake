extends Node2D

const SHIP_HORIZONTAL_SPEED = 150
const SHIP_VERTICAL_SPEED = 150
const BULLET_SPEED = 300
const BULLET_Y_OFFSET = 50
const ENEMY_MAX_WIGGLE = 1000

var ship
var bullet
var enemy
var is_bullet

func _ready():
	ship = get_node("ship")
	
	bullet = get_node("bullet")
	bullet.hide()
	
	enemy = get_node("enemy")
	enemy.connect("body_enter", self, "_on_enemy_body_enter")
	
	set_process(true)

func _process(delta):
	ship.set_pos(get_ship_pos(delta))
	process_bullet(delta)
	process_enemy(delta)
	
	
func process_enemy(delta):
	var enemy_pos = enemy.get_pos()
	# enemy_pos.x = ENEMY_MAX_WIGGLE * sin(delta)
	enemy.set_pos(enemy_pos)
	
	
func _on_enemy_body_enter(body):
	enemy.hide()
	

func process_bullet(delta):
	var bullet_pos = bullet.get_pos()
	
	if Input.is_action_pressed("ui_accept") and not is_bullet:
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


func get_ship_pos(delta):
	var ship_pos = ship.get_pos()
	
	if (Input.is_action_pressed("ui_up")):
		ship_pos.y += -SHIP_HORIZONTAL_SPEED * delta

	if (Input.is_action_pressed("ui_down")):
		ship_pos.y += SHIP_HORIZONTAL_SPEED * delta
	
	if (Input.is_action_pressed("ui_left")):
		ship_pos.x += -SHIP_VERTICAL_SPEED * delta

	if (Input.is_action_pressed("ui_right")):
		ship_pos.x += SHIP_VERTICAL_SPEED * delta
	
	return ship_pos
	
	