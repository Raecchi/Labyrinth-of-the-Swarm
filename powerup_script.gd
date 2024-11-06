extends Area2D

var time = 0
var color_change = false

func _physics_process(delta):
	time += 1
	if time >= 900 and time % 7 == 0:
		if color_change:
			modulate = Color(1,1,1)
			color_change = false
		else:
			modulate = Color(0.675,0.7,0.455)
			color_change = true
	if time == 1080:
		queue_free()
