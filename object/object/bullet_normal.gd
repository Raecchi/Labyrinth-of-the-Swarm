extends Area2D

const BULLET_HIT_PATH = preload("res://object/bullet_hit.tscn")

var speed = 3.5
var direction = Vector2.ZERO
var hp = 1
var player_id = 0
var type = 1

func _ready():
	SfxController.play_shoot()

func _physics_process(delta):
	#SfxController.play_shoot()
	position += direction * speed 


func bullet_rotate():
	if direction != Vector2.ZERO:
		rotation = direction.angle()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if type == 1:
			SfxController.play_bullet_hit()
		else:
			SfxController.play_laser_hit()
		body.hp -= 1
		body.player_id = player_id
		#print(body.hp)
	hp -= 1
	if hp <= 0 or body.is_in_group("walls"):
		var explosion = BULLET_HIT_PATH.instantiate()
		explosion.position = global_position
		get_parent().add_child(explosion)
		queue_free()
