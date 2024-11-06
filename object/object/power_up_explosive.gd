extends "res://powerup_script.gd"


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.shotgun = false
		body.bullet_counter = 15
		body.bullet_type = 2
		body.change_gun = true
		SfxController.play_pick_up()
		queue_free()
