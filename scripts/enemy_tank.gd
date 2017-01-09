extends "res://scripts/enemy.gd"

const SPEED = 2
const SCORE_ENEMY = 250
const CALL_BASE_FIXED_PROCESS = false


func _fixed_process(delta):
	var pos = get_pos()
	pos.x += SPEED
	set_pos(pos)
	
	
func set_enemy_scale(pos):
	pass