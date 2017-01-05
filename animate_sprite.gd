extends Sprite


var elapsed = 0
var frames_count


func _ready():
	frames_count = get_vframes() *  get_hframes()


func play_explosion():
	set_process(true)


func _process(delta):
	elapsed = elapsed + delta
	
	if elapsed > 0.1:
		var frame = get_frame()
		if frame == frames_count - 1:
			set_process(false)
		else:
			set_frame(frame + 1)
			
		elapsed = 0