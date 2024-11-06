extends Area2D

var timer = 0
var player_id = 0

func _ready():
	SfxController.play_explosion()

func _physics_process(delta):
	timer += 1
	if timer == 30:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.hp -= 3
		body.player_id = player_id
