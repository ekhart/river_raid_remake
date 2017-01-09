extends CanvasLayer

const SCREEN_HEIGHT_WITHOUT_UI = 565 

const FUEL_MAX = 100
const FUEL_LOSS_STEP = 0.1
const FUEL_REFUEL_STEP = 1
const FUEL_ALMOST_MAX = FUEL_MAX - FUEL_REFUEL_STEP

const LIVES_MAX = 3
const LIVES_STEP = 1
const LIVES_NEXT = 10000


var game
var score
var score_label
var fuel
var fuel_slider
var lives
var lives_label
var bridge
var bridge_label


func _ready():
	game = get_parent()
	score = 0
	score_label = get_node("score")
	fuel = FUEL_MAX
	fuel_slider = get_node("fuel")
	lives = LIVES_MAX
	lives_label = get_node("lives")
	bridge = 1
	bridge_label = get_node("bridge")


func set_fuel():
	if game.is_refuel and fuel < FUEL_ALMOST_MAX:
		fuel += FUEL_REFUEL_STEP
		if fuel >= FUEL_ALMOST_MAX:
			game.ship.play_until_end("max_fuel")

	fuel -= FUEL_LOSS_STEP
	fuel_slider.set_value(fuel)
	game.ship.play_until_end("refuel", game.is_refuel)
	
	if fuel < 0:
		game.ship.destroy()
		fuel = FUEL_MAX


func set_score(points):
	var last_score = score
	
	score += points
	score_label.set_text(str(score))
	
	var last_mod = last_score % LIVES_NEXT
	var current_mod = score % LIVES_NEXT
	
	if last_mod > current_mod:
		set_lives(LIVES_STEP)


func set_lives(number = -LIVES_STEP):
	lives += number
	lives_label.set_text(str(lives))
	
	if number == -LIVES_STEP:
		game.set_global_pos(Vector2(0, 0)) # side effect: effect get_pos for last bridge
		# reset all game (not only pos but also enemies pos)
		
		var bridge_pos = game.last_bridge.get_pos()
		game.set_pos(Vector2(0, -bridge_pos.y + SCREEN_HEIGHT_WITHOUT_UI))
		
		game.ship.set_global_pos(game.ship.START_POS) # reset ship position
		game.last_bridge.show()
		
		fuel = FUEL_MAX
		game.start(false)


func set_bridge():
	bridge += 1
	bridge_label.set_text(str(bridge))
	
	
func show_over():
	get_node("over").show()