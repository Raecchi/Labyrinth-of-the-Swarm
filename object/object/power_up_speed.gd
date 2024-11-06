extends "res://powerup_script.gd"


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.speed_timer = 0
		body.speed *= 1.25
		body.speed_boost = true
		SfxController.play_pick_up()
		queue_free()
