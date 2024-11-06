extends "res://powerup_script.gd"


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.shotgun = true
		body.bullet_counter = 120
		body.bullet_type = 0
		body.change_gun = true
		SfxController.play_pick_up()
		queue_free()
