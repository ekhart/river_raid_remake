extends AnimatedSprite


var elapsed = 0


func _ready():
   set_process(true)


func _process(delta):
   elapsed = elapsed + delta

   if elapsed > 0.1:
      if get_frame() == get_sprite_frames().get_frame_count("default") - 1:
         set_frame(0)
      else:
         self.set_frame(get_frame() + 1)

      elapsed = 0