extends Area2D


const SCORE = 800
var game


func _ready():
	game = get_parent().get_parent()


func _on_bridge_area_enter(area):
	if area == game.bullet:
		disconnect("area_enter", self, "_on_bridge_area_enter")
		hide()
		
		game.bullet.hide_bullet()
		game.set_score(SCORE)
		game.last_bridge = self
		
	if area == game.ship:
		game.ship.destroy()
