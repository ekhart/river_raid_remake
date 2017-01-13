extends "res://scripts/enemy.gd"


const SPEED = 2
const SCORE_ENEMY = 250
const CALL_BASE_FIXED_PROCESS = false


var bridge
var timer_destroy


func _ready():
	timer_destroy = get_node("destroy")


func _fixed_process(delta):
	var pos = get_pos()
	pos.x += SPEED
	set_pos(pos)


func set_bridge(_bridge):
	if _bridge == null:
		timer_destroy.start()
		bridge = null
	else:
		timer_destroy.stop()
		bridge = _bridge


func _on_destroy_timeout():
	timer_destroy.stop()
	destroy()
