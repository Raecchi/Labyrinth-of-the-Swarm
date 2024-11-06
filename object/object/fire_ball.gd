extends Area2D

var speed = 0

func _physics_process(delta):
	position.y += speed


func set_speed():
	speed = 3


func _on_body_entered(body):
	if body.is_in_group("player") and body.invincibility == false and body.is_hurt == false:
		body.hp -= 1
		body.is_hurt = true
		body.moveable = false
		body.modulate = Color(1,1,1,0.5)
	else:
		queue_free()
