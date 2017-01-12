extends "res://scripts/enemy.gd"


const SPEED = 3
const SCORE_ENEMY = 100
const CALL_BASE_FIXED_PROCESS = false


func _fixed_process(delta):
	var pos = get_pos()
	pos.x += SPEED
	set_pos(pos)