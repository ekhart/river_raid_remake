extends KinematicBody2D

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	move(Vector2(0, 1)) # move down 1 pixel per physics frame