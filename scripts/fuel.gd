extends Area2D


const SCORE = 100


var game


func _ready():
	game = get_parent().get_parent()
	get_node("sprite/animation").play("animation")


func _on_fuel_area_enter(area):
	game.is_refuel = area == game.ship
	
	if area == game.bullet:
		destroy()
		game.bullet.hide_bullet()
		game.hud.set_score(SCORE)


func _on_fuel_area_exit(area):
	if area == game.ship:
		game.is_refuel = false


func destroy():
	get_node("sprite").hide()
	get_node("boom").show()
	get_node("boom_sfx").play("boom")
	get_node("boom/animation").play("animation")
	disconnect("area_enter", self, "_on_fuel_area_enter")
	disconnect("area_exit", self, "_on_fuel_area_exit")

func _on_visibility_exit_screen():
	queue_free()
