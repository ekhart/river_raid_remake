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
		
	var file = area.get_script().get_path().get_file()
	if file == tank_script:
		tank = area


func _on_bridge_area_exit( area ):
	var file = area.get_script().get_path().get_file()
	if tank != null and file == tank_script:
		tank = null


func destroy():
	get_node("sprite").hide()
	get_node("boom_sfx").play("boom")
	get_node("boom/animation").play("boom")
	disconnect("area_enter", self, "_on_bridge_area_enter")
	
	if tank != null:
		tank.destroy()


func get_score():
	if tank != null:
		return SCORE + tank.SCORE_ENEMY
	return SCORE