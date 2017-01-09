extends Area2D


const SCORE = 800
const SCORE_TANK = 250

var game
var tank
var tank_script = "enemy_tank.gd"


func _ready():
	game = get_parent().get_parent()
	tank = null


func _on_bridge_area_enter(area):
	if area == game.bullet:
		destroy()
		game.on_bullet_bridge_area_enter(self)

	if area == game.ship:
		game.ship.destroy()
		
	if is_tank(area):
		tank = area


func _on_bridge_area_exit( area ):
	if is_tank() and is_tank(area):
		tank = null


func destroy():
	get_node("sprite").hide()
	get_node("boom_sfx").play("boom")
	get_node("boom/animation").play("boom")
	disconnect("area_enter", self, "_on_bridge_area_enter")
	if is_tank():
		tank.destroy()


func get_score():
	if is_tank():
		return SCORE + tank.SCORE_ENEMY
	return SCORE
	

func is_tank(area = null):
	if area == null:
		return tank != null
	else:
		var file = area.get_script().get_path().get_file()
		return file == tank_script