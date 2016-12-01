extends Node2D

const SHIP_HORIZONTAL_SPEED = 150
const SHIP_VERTICAL_SPEED = 150
const BULLET_SPEED = 300

var ship
var bullet

func _ready():
	ship = get_node("ship")
	bullet = get_node("bullet")
	bullet.hide()
	set_process(true)

func _process(delta):
	ship.set_pos(get_ship_pos(delta))
	
	if (Input.is_action_pressed("ui_accept")):
		bullet.show()
		
	if (bullet.is_visible()):
		var bullet_pos = bullet.get_pos()
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
	
	