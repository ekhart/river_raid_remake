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
		destroy_parts()
		game.on_bullet_bridge_area_enter(self)

	if area == game.ship:
		game.ship.destroy()

	if is_tank(area) and alive():
		tank = area
		tank.set_bridge(self)


func _on_bridge_area_exit( area ):
	if is_tank() and is_tank(area):
		tank.set_bridge(null)
		tank = null
		


func destroy_parts():
	var id = get_group_id()
	for bridge in get_parent().get_children():
		if bridge.has_method("get_group_id"):
			var bridge_id = bridge.get_group_id()
			if not_default_group(bridge_id) and id == bridge_id and bridge.alive():
				bridge.destroy()


func get_group_id():
	if has_group():
		return get_groups()[0]
	return null


func has_group():
	return get_groups().size() >= 1
	
	
func not_default_group(id):
	return id != null

func alive():
	return get_node("sprite").is_visible()


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