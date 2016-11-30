extends Node2D

const SHIP_HORIZONTAL_SPEED = 150
const SHIP_VERTICAL_SPEED = 150

var ship

func _ready():
	ship = get_node("ship")
	set_process(true)

func _process(delta):
	var ship_pos = ship.get_pos()
	
	if (Input.is_action_pressed("ui_up")):
		ship_pos.y += -SHIP_HORIZONTAL_SPEED * delta

	if (Input.is_action_pressed("ui_down")):
		ship_pos.y += SHIP_HORIZONTAL_SPEED * delta
	
	if (Input.is_action_pressed("ui_left")):
		ship_pos.x += -SHIP_VERTICAL_SPEED * delta

	if (Input.is_action_pressed("ui_right")):
		ship_pos.x += SHIP_VERTICAL_SPEED * delta
		
	ship.set_pos(ship_pos)
	