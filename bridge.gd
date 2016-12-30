extends Area2D


const SCORE = 800
var game


func _ready():
	game = get_parent().get_parent()


func _on_bridge_area_enter(area):
	if area == game.bullet:
		# queue_free()
		hide()
		
		game.bullet.hide_bullet()
		game.set_score(SCORE)
		game.last_bridge = self
