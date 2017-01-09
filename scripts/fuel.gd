extends Area2D


var game


func _ready():
	game = get_parent().get_parent()


func _on_fuel_area_enter(area):
	game.is_refuel = area == game.ship


func _on_fuel_area_exit(area):
	if area == game.ship:
		game.is_refuel = false
