extends Area2D

var direction
var speed = 120

func _physics_process(delta):
	position += direction * speed * delta 



func _on_body_entered(body):
	if body.is_in_group("player") and body.invincibility == false and body.is_hurt == false:
		body.hp -= 1
		if body.player_id == 1:
			GameData.set_player_1_hp(body.hp)
		elif body.player_id == 2:
			GameData.set_player_2_hp(body.hp)
		body.is_hurt = true
		body.moveable = false
		body.modulate = Color(1,1,1,0.5)
		SfxController.play_hurt()
		queue_free()
	else:
		queue_free()



func _on_area_entered(area):
	if area.is_in_group("bubble"):
		queue_free()
