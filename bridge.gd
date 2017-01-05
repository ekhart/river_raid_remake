extends Area2D


const SCORE = 800
var game


func _ready():
	game = get_parent().get_parent()


func _on_bridge_area_enter(area):
	if area == game.bullet:
		destroy()
		game.on_bullet_bridge_area_enter(self)

	if area == game.ship:
		game.ship.destroy()


func destroy():
	disconnect("area_enter", self, "_on_bridge_area_enter")
	get_node("boom").play_explosion()
	get_node("Sprite").hide()