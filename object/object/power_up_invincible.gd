extends "res://powerup_script.gd"


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.turn_on_powerup(2)
		SfxController.play_pick_up()
		queue_free()
