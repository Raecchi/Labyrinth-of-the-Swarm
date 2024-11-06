extends AnimatedSprite2D
var time = 0

func _physics_process(delta):
	time += 1
	if time == 15:
		queue_free()
